#!/usr/bin/env nu

# Split an rsync-style remote destination into its SSH host and directory.
def remote_directory [destination: string] {
  let parts = ($destination | split row ":")

  if ($parts | length) < 2 or ($parts | first | is-empty) or ($parts | skip 1 | str join ":" | is-empty) {
    error make {msg: "Destination must use rsync remote syntax: user@host:directory"}
  }

  {
    host: ($parts | first)
    directory: ($parts | skip 1 | str join ":")
  }
}

# Quote a remote directory for the shell command executed by SSH.
def quote_remote_path [directory: string] {
  let quote = {|path|
    let escaped = ($path | str replace --all (char single_quote) $"(char double_quote)(char single_quote)(char double_quote)(char single_quote)")
    $"(char single_quote)($escaped)(char single_quote)"
  }

  if ($directory | str starts-with "~/") {
    $"~/(do $quote ($directory | str substring 2..))"
  } else {
    do $quote $directory
  }
}

# Mirror selected repository subdirectories to a remote with rsync.
# Files ignored by Git are excluded and therefore preserved when they already exist remotely.
def main [
  destination: string # Remote rsync destination, such as user@host:directory
  ...directories: string # Subdirectories to sync, all below one Git repository root
  --verbose # Show rsync's output
  --dry-run # Show what would change without making changes
] {
  if ($directories | is-empty) {
    error make {msg: "Specify at least one directory to sync"}
  }

  let expanded_directories = ($directories | each {|directory|
    let expanded = ($directory | path expand)
    if ($expanded | path type) != "dir" {
      error make {msg: $"Not a directory: ($directory)"}
    }
    $expanded
  })
  let repo_roots = ($expanded_directories | each {|directory|
    ^git -C $directory rev-parse --show-toplevel | str trim
  } | uniq)

  if ($repo_roots | length) != 1 {
    error make {msg: "All directories must belong to the same Git repository"}
  }

  let repo_root = ($repo_roots | first)
  let relative_directories = ($expanded_directories | each {|directory|
    let relative = ($directory | path relative-to $repo_root)
    if $relative == "." {
      error make {msg: "Refusing to sync the repository root; specify subdirectories instead"}
    }
    $relative
  } | uniq)
  let remote = (remote_directory $destination)
  let exclude_file = (^mktemp | str trim)
  let ignored_paths = (
    ^git -C $repo_root ls-files -i -o --exclude-standard --directory -- .
    | lines
    | where {|path| not ($path | is-empty) }
    | each {|path| $"/($path)" }
  )

  try {
    let exclude_rules = if ($ignored_paths | is-empty) {
      ""
    } else {
      $ignored_paths | append "" | str join "\n"
    }
    $exclude_rules | save --force $exclude_file

    ^ssh $remote.host $"mkdir -p -- (quote_remote_path $remote.directory)"

    let rsync_args = [
      "-a"
      "--delete-after"
      $"--exclude-from=($exclude_file)"
      "--relative"
      ...($relative_directories | each {|directory| $"./($directory)/" })
      $"($destination)/"
    ]
    let rsync_args = if $dry_run { $rsync_args | append "--dry-run" } else { $rsync_args }
    let rsync_args = if $verbose { $rsync_args | append "--verbose" } else { $rsync_args }

    cd $repo_root
    ^rsync ...$rsync_args
  } finally {
    ^rm -f $exclude_file
  }
}
