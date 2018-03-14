# If not running interactively, don't do anything
[ -z "$PS1" ] && return

[ -d ~/bin ] && export PATH=~/bin:$PATH

set -o noclobber

# history control
export HISTCONTROL=ignoredups:ignorespace
export HISTSIZE=10000000000
export HISTFILESIZE=10000000000000
shopt -s histappend
shopt -s checkwinsize
if [[ $($SHELL --version) =~ 'version 4' ]]; then
  shopt -s autocd
  shopt -s globstar
fi
stty -ixon

export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad
export EDITOR=vim

# alias awk='awk -F \\t'
# alias count='sort | uniq -c | sort -g'
alias now_d='date +%Y%m%d'
alias now_dt='date +%Y%m%dT%H%M%S'
alias py='python'
alias ipy='ipython -i'

alias lsa='ls -la'
alias perlsed='perl -pe'

# tr -s indicates that multiple matches of the first string are converted into
# a single instance of the second string
alias flatten="tr -s [:space:] ' '"
# tokenize removes all characters except alphanumerics (A-Za-z0-9) and
# apostrophe (') and splits on whitespace into lines
# the deletion must come first in case there are any tokens that are only punctuation
alias tokenize="tr -C -s \"[:alnum:]'\" [:space:] | tr -s [:space:] '\n'"
alias lower="tr [:upper:] [:lower:]"
alias upper="tr [:lower:] [:upper:]"

cdp() {
  mkdir -p $1
  cd $1
}
source_if_exists() {
  [[ -e "$1" ]] && source "$1"
}
fullpath() {
  # http://stackoverflow.com/questions/5265702/how-to-get-full-path-of-a-file
  echo $(cd $(dirname "$1") && pwd -P)/$(basename "$1")
}
sha1() {
  if [ $# -eq 1 ]; then
    printf "%s" $1 | shasum -a 1 | awk '{print $1}'
  else
    >&2 printf '%s must be called with exactly one argument, not %d.\n' "$FUNCNAME" "$#"
    return 1
  fi
}

# only define the function 'o' if the command 'open' exists
if command -v open >/dev/null 2>&1; then
  o() {
    if [ $# -eq 0 ]; then
      # if there were no arguments specified, simply open the current directory
      >&2 printf 'Opening current directory: %s\n' "$(pwd)"
      open .
    else
      open "$@"
    fi
  }
fi

# -e is true for existing files
if [ -e ~/.env ]; then
  # 'set -a' directs the shell to promote all variable assignments to environment variables
  set -a
  source ~/.env
  # 'set +a' turns off the auto-environment setting
  set +a
fi

# If Sublime Text is installed (the `subl` command exists), set up `a` and `e` functions.
# We can't use aliases since we default to current directory when no arguments are supplied.
if command -v subl >/dev/null 2>&1; then
  e() {
    subl "${@-.}"
  }
  a() {
    subl -a "${@-.}"
  }
fi

source_if_exists "$HOME/.localrc"
source_if_exists "$HOME/.iterm2_shell_integration.bash"

#bind 'set page-completions off'
#bind 'set completion-query-items 500'

export PS1="\[$(tput setaf 2)\][\u@$MACHINE \w]\$\[$(tput sgr0)\] "
shortPS() {
  # only show basename of working directory, and show it in magenta, instead of blue
  export PS1="\[$(tput setaf 2)\][\u@$MACHINE \[$(tput setaf 5)\]\W\[$(tput setaf 2)\]]\$\[\$(tput sgr0)\] "
}

BASHRC_D=$(dirname $(readlink $BASH_SOURCE))/bashrc.d
#source $BASHRC_D/timer
#source $BASHRC_D/lastwd
