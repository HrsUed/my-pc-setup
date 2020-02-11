function get_git-branch_name() {
  git branch --list > /dev/null 2>&1
  if [[ $? -eq 0 ]];then
    echo "($(git branch --list | grep '*' | awk '{print $2}')) "
  fi
}

export PS1='\[\e[0;36m\]\W $(get_git-branch_name)\$\[\e[0;0m\] '

alias ls='ls -FG'
alias ll='ls -l'
alias git-branch-prune='git branch -d $(git branch | grep -e "feature" -e "hotfix" | awk "{print $1}")'
alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"
