# ~/.bash_profile: executed by bash(1) for login shells.

# Keep the system/user login profile behavior, then make sure interactive
# Bash login shells also get the prompt, aliases, and completions in ~/.bashrc.
if [ -f ~/.profile ]; then
    . ~/.profile
fi

if [[ $- == *i* && -z "${BASHRC_SOURCED:-}" && -f ~/.bashrc ]]; then
    . ~/.bashrc
fi
