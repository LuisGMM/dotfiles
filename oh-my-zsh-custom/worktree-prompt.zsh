# Worktree indicator for prompt
# Uses precmd hook to add indicator AFTER theme sets PROMPT

_worktree_info() {
    local wt_path=$(git rev-parse --git-dir 2>/dev/null)
    if [[ "$wt_path" == *"/worktrees/"* ]]; then
        local task_id=$(echo "$wt_path" | grep -oP 'worktrees/\K[^/]+')
        echo "%{$fg[yellow]%}[wt:$task_id]%{$reset_color%}"
    fi
}

# Use RPROMPT for worktree indicator (right side of prompt)
# This is cleaner and doesn't interfere with theme's PROMPT
precmd_worktree() {
    local wt=$(_worktree_info)
    if [[ -n "$wt" ]]; then
        RPROMPT="$wt"
    else
        RPROMPT=""
    fi
}

# Add to precmd hooks
autoload -Uz add-zsh-hook
add-zsh-hook precmd precmd_worktree
