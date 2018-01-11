# If not running interactively, don't do anything
[[ $- != *i* ]] && return

while read module; do
	source "$module"
done < <(find "$HOME/.bash.d/" -type f,l)

[ -f "$HOME/.dircolors" ] && which dircolors >/dev/null && eval "$(dircolors -b $HOME/.dircolors)"


# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
[ "${BASH_VERSINFO[0]}" -ge 4 ] && shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"


[ -f ~/.fzf.bash ] && source ~/.fzf.bash
