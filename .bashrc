
test -s ~/.alias && . ~/.alias || true

#Working commented in favor of Starship
#PROMPT_COMMAND='PS1_CMD1=$(git branch --show-current 2>/dev/null)'; PS1='[\d] [\T] [\W] [${PS1_CMD1}] >> '




# Custom prompt
# Layout: [hh:mm AM/PM]|[cwd]|[branch]|[git status]
#         >>
# The git segment only appears when inside a git repo.
#
# ----------------------------------------------------------------------------
# COLORS  (single source of truth — change a value here and it applies
# everywhere it's used).
#
# Style: each segment is a BACKGROUND-colored box with BLACK foreground text.
# Black text on a solid mid/light background stays legible on every theme,
# light or dark. Pick light-to-mid background tones so black text reads well.
# Each code is wrapped in \[ \] so bash counts the prompt width correctly.
# Browse colors with:  for i in {0..255}; do
#   printf '\e[48;5;%sm%3s\e[0m ' "$i" "$i"; done; echo
# ----------------------------------------------------------------------------
C_RESET='\[\e[0m\]'
FG_BLACK='\[\e[38;5;16m\]'    # black foreground text used by every box

BG_TIME='\[\e[48;5;250m\]'    # time      - light gray
BG_DIR='\[\e[48;5;75m\]'      # directory - light blue
BG_BRANCH='\[\e[48;5;114m\]'  # branch    - light green
BG_GIT='\[\e[48;5;215m\]'     # git status- light orange
BG_PROMPT='\[\e[48;5;250m\]'  # >> prompt char - light gray

__build_prompt() {
    # --- Time (12-hour with AM/PM) ---
    # printf '%(...)T' is a bash builtin (4.2+) and avoids forking `date`.
    local time
    printf -v time '%(%I:%M %p)T' -1

    # --- Current directory only (not the full path / breadcrumbs) ---
    local dir
    if [[ "$PWD" == "$HOME" ]]; then
        dir="~"
    else
        dir="${PWD##*/}"
    fi

    # --- Git segment ---
    # A single `git status` call gathers the branch, ahead/behind counts and all
    # file states at once. This is the most performant approach for large repos
    # because we avoid spawning multiple git processes.
    #
    # UNTRACKED COUNTING:
    # By default git collapses an untracked DIRECTORY into one entry, so a new
    # folder with 11 files counts as ?1 (this is the fast, default behavior).
    # To count every untracked file individually, switch the flag below:
    #   ?1 (folders collapsed, fast) :  --untracked-files=normal   <-- current
    #   full per-file count (slower) :  --untracked-files=all
    # Just edit the flag on the `git status` line below.
    #
    # Prefer it globally for ALL git commands instead? Run once in a terminal:
    #   git config --global status.showUntrackedFiles all
    # (then this prompt follows it too). Undo with: ... showUntrackedFiles normal
    local git_seg=""
    local status
    if status=$(git status --porcelain=v2 --branch --untracked-files=normal 2>/dev/null); then
        local branch="" ahead=0 behind=0
        local staged=0 modified=0 deleted=0 untracked=0 conflicted=0
        local line xy x y ab

        while IFS= read -r line; do
            case "$line" in
                '# branch.head '*)
                    branch="${line#\# branch.head }"
                    ;;
                '# branch.ab '*)
                    # Format: "# branch.ab +A -B"
                    ab="${line#\# branch.ab }"
                    ahead="${ab%% *}";  ahead="${ahead#+}"
                    behind="${ab##* }"; behind="${behind#-}"
                    ;;
                '1 '*|'2 '*)
                    # Ordinary/renamed entry: chars 3-4 are the XY status code.
                    # X = index (staged), Y = worktree.
                    xy="${line:2:2}"
                    x="${xy:0:1}"
                    y="${xy:1:1}"
                    [[ "$x" != "." ]] && staged=$((staged + 1))
                    [[ "$y" == "M" ]] && modified=$((modified + 1))
                    [[ "$y" == "D" ]] && deleted=$((deleted + 1))
                    ;;
                'u '*)
                    conflicted=$((conflicted + 1))
                    ;;
                '?'*)
                    untracked=$((untracked + 1))
                    ;;
            esac
        done <<< "$status"

        # Build the status details (only non-zero items are shown).
        local details=""
        (( ahead > 0 && behind > 0 )) && details+=" ^${ahead}v${behind}"  # diverged
        (( ahead > 0 && behind == 0 )) && details+=" ^${ahead}"           # ahead
        (( behind > 0 && ahead == 0 )) && details+=" v${behind}"          # behind
        (( staged     > 0 )) && details+=" +${staged}"                    # staged
        (( modified   > 0 )) && details+=" ~${modified}"                  # modified
        (( deleted    > 0 )) && details+=" -${deleted}"                   # deleted
        (( untracked  > 0 )) && details+=" ?${untracked}"                 # untracked
        (( conflicted > 0 )) && details+=" !${conflicted}"                # conflicted

        # Branch in its own box; git status (if any) in a separate box.
        # Detached HEAD reports the literal text "(detached)" as the branch.
        git_seg="${BG_BRANCH}${FG_BLACK} ${branch} ${C_RESET}"
        [[ -n "$details" ]] && git_seg+="${BG_GIT}${FG_BLACK} ${details# } ${C_RESET}"
    fi

    # PS1 expands \n to a real newline, so the prompt char sits on its own line.
    # Each segment is a padded background box with black text.
    # PS1="${BG_TIME}${FG_BLACK} ${time} ${C_RESET}${BG_DIR}${FG_BLACK} ${dir} ${C_RESET}${git_seg}\n${BG_PROMPT}${FG_BLACK}  ${C_RESET} "
    PS1="${BG_TIME}${FG_BLACK} ${time} ${C_RESET}${BG_DIR}${FG_BLACK} ${dir} ${C_RESET}${git_seg}\n  "
}

PROMPT_COMMAND='__build_prompt'






#dotnet
export DOTNET_ROOT="$HOME/.dotnet"
export PATH="$PATH:$DOTNET_ROOT:$DOTNET_ROOT/tools"
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export DOTNET_WATCH_SUPPRESS_EMOJIS=1
export DOTNET_WATCH_RESTART_ON_RUDE_EDIT=1
# export DOTNET_CLI_PERF_LOG=1
#dotnet


#nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#nvm

# pnpm
export PNPM_HOME="/home/user/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac
# pnpm end

#rust
. "$HOME/.cargo/env"
#rust

#go
export PATH=$PATH:/usr/local/go/bin
#go

#java
export JAVA_HOME=/opt/java/jdk-25.0.3+9
export PATH=$JAVA_HOME/bin:$PATH
#java


#gradle
export GRADLE_HOME=/opt/gradle/gradle-9.5.1
export PATH=$GRADLE_HOME/bin:$PATH
#gradle


#Starship config
# eval "$(starship init bash)"
