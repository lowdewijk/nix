#!/usr/bin/env nu

def main [
    worktree_name: string # The name of the worktree directory
    branch: string # The name of the worktree branch
    --from: string = "origin/main" # If the branch is new, create a branch from this ref
] {
  let repo = ($env.HOME | path join projects violencev2 oddity)
  let worktrees = ($env.HOME | path join projects violencev2 worktrees)
  let worktree_path = ($worktrees | path join $worktree_name)

  git -C $repo fetch origin

  let local_branch_exists = (
      do { git -C $repo show-ref --verify --quiet $"refs/heads/($branch)" }
      | complete
      | get exit_code
  ) == 0

  let remote_branch_exists = (
      do { git -C $repo show-ref --verify --quiet $"refs/remotes/origin/($branch)" }
      | complete
      | get exit_code
  ) == 0

  if $local_branch_exists {
    print $"Using worktree path: ($worktree_path) for existing local branch ($branch)"
    git -C $repo worktree add $worktree_path $branch
  } else if $remote_branch_exists {
    print $"Using worktree path: ($worktree_path) for existing remote branch origin/($branch)"
    git -C $repo worktree add --track -b $branch $worktree_path $"origin/($branch)"
  } else {
    print $"Using worktree path: ($worktree_path) for new branch ($branch) \(branched from ($from)\)"
    git -C $repo worktree add --no-track -b $branch $worktree_path $from
  }

  let ml2_path = ($worktree_path | path join ml2)

  cp envrc-template ($ml2_path | path join .envrc)
  direnv allow $ml2_path

  open --raw neoconf-template.json
  | str replace --all "{{WORKTREE_NAME}}" $worktree_name
  | save --force ($ml2_path | path join .neoconf.json)

  cp ($repo | path join ml2 flake.lock) $ml2_path

  direnv allow $ml2_path

  cd $ml2_path
  nix run .#install-precommit-hooks
}
