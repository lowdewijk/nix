#!/usr/bin/env nu

def place_envrc [worktree_path: string dir_name: string] {
  let envrc = [
    'source_up_if_exists' 
    'git_root="$(git rev-parse --show-toplevel)"'
    $'use flake "git+file://$git_root?dir=($dir_name)" --reference-lock-file "$PWD/flake.lock" --no-write-lock-file'
  ]

  let full_path = $worktree_path | path join $dir_name
  ($envrc | str join "\n") | save ($full_path | path join .envrc)
  ^direnv allow $full_path
}

def place_neoconf [worktree_name: string ml2_path: string] {
  let neoconf = '{
  "run-on-save": {
    "commands": ["sync-training-3", "sync-training-4"],
    "success_msg": "Synced ml2 {{WORKTREE_NAME}}"
  },
  "commands": {
    "sync-training-4": {
      "command":  "sync-remote",
      "args":  ["oddity@training-4:~/lodewijk/ml2/worktrees/{{WORKTREE_NAME}}"],
    },
    "sync-training-3": {
      "command":  "sync-remote",
      "args":  ["oddity@training-3:~/lodewijk/ml2/worktrees/{{WORKTREE_NAME}}"],
    }
  }
}' | str replace --all "{{WORKTREE_NAME}}" $worktree_name
  $neoconf | save --force ($ml2_path | path join .neoconf.json)
}
  
  

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

  place_envrc  $worktree_path "ml2"
  place_envrc $worktree_path "tools/cocobaccie"
  place_envrc $worktree_path "engine"

  let ml2_path = ($worktree_path | path join ml2)
  place_neoconf $worktree_name $ml2_path 

  cd $ml2_path
  ^nix run .#install-precommit-hooks
}
