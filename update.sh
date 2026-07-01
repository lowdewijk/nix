#!/usr/bin/env bash
set -euo pipefail

readonly FLAKE_FILE="flake.nix"
readonly CUTOFF_DATE="$(date --date='14 days ago' +%Y-%m-%dT%H:%M:%SZ)"

require_cmd() {
  command -v "$1" >/dev/null 2>&1 || {
    echo "missing required command: $1" >&2
    exit 1
  }
}

escape_ere() {
  sed 's/[][(){}.^$*+?|\\/-]/\\&/g' <<<"$1"
}

trailing_rev() {
  local repo="$1"
  local ref="${2:-}"
  local commits_url="https://api.github.com/repos/${repo}/commits?until=${CUTOFF_DATE}&per_page=1"

  if [[ -n "$ref" ]]; then
    commits_url="${commits_url}&sha=${ref}"
  fi

  curl -fsSL "$commits_url" |
    jq -r '.[0].sha // empty'
}

github_input_urls() {
  nix flake metadata --json --no-write-lock-file . |
    jq -r '
      .locks.nodes
      | to_entries[]
      | select(.key != "root")
      | .value.original
      | select(.type == "github")
      | "github:\(.owner)/\(.repo)" + (if .ref then "/\(.ref)" else "" end)
    ' |
    sort -u
}

pin_github_input_urls() {
  while IFS= read -r url; do
    [[ -n "$url" ]] || continue

    local repo_path="${url#github:}"
    local owner remainder repo_name ref rev escaped_repo

    owner="${repo_path%%/*}"
    remainder="${repo_path#*/}"
    repo_name="${remainder%%/*}"
    ref=""
    if [[ "$remainder" == */* ]]; then
      ref="${remainder#*/}"
    fi

    repo="${owner}/${repo_name}"
    rev="$(trailing_rev "$repo" "${ref:-}")"

    if [[ -z "$rev" ]]; then
      echo "no commit at least 14 days old found for ${url}" >&2
      exit 1
    fi

    escaped_repo="$(escape_ere "$repo")"
    echo "Setting $repo_name to $rev"
    sed -i -E "s#github:${escaped_repo}(/[^\"?]*)?#github:${repo}/${rev}#g" "$FLAKE_FILE"
  done < <(github_input_urls)
}

require_cmd curl
require_cmd jq
require_cmd nix
require_cmd sed

pin_github_input_urls
