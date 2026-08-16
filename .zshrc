# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"
# Has weird character width
# Example:
#    is not a diamond
HAS_WIDECHARS="false"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

alias cls='clear'
alias cat='bat'
alias clipcopy='xclip -selection clipboard'

# Shows top 5 memory consuming applications, grouped by name
topmem_func() {
    ps -eo rss,args --no-headers |
    awk '{
        rss = $1;
        cmd = $2;
        app_name = cmd;

        # For interpreters, find the script name to use as the app name
        if (cmd ~ /\/(python|node|java|perl|ruby)[0-9.]*$/) {
            for (i = 3; i <= NF; i++) {
                # Find first argument that is not an option and looks like a path/script
                if ($i !~ /^-/ && $i ~ /[\/\.]/) {
                    app_name = $i;
                    break;
                }
            }
        }
        
        # Group all kernel threads together
        if (cmd ~ /^\[.*\]$/) {
            app_name = "Kernel Threads";
        }

        # Sum RSS and count processes for each unique application name
        rss_sum[app_name] += rss;
        count[app_name]++;
    }
    END {
        for (app in rss_sum) {
            # Print in a machine-sortable format with a tab separator
            printf "%f\t%s (%d processes)\n", rss_sum[app], app, count[app];
        }
    }' |
    sort -rn | # Sort numerically in reverse
    head -n 5 | # Take the top 5
    awk -F'\t' '{
        # Format the final output into a clean table
        rss_kb = $1;
        rest = $2;
        printf "%10.2f MB | %s\n", rss_kb/1024, rest;
    }'
}
alias topmem='topmem_func'

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export PATH="/home/maendeleo/Python-3.12.12:$PATH"

# Алиасы для переключения тем
alias light="~/.local/bin/switch-theme.sh light"
alias dark="~/.local/bin/switch-theme.sh dark"

alias tn="tmux new-session -s"
alias tl="tmux list-sessions"
alias ta="tmux attach-session"

alias idea="~/.local/share/JetBrains/Toolbox/apps/intellij-idea/bin/idea.sh"

alias rw='pkill waybar; waybar > /dev/null 2>&1 &!'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
export GOOGLE_CLOUD_PROJECT="phonic-monolith-477317-a4"
alias dotfiles='/usr/bin/git --git-dir=/home/maendeleo/.cfg/ --work-tree=/home/maendeleo'
