# Scavenged from Git 1.6.5.x contrib/completion/git_completion.bash
# __git_ps1 accepts 0 or 1 arguments (i.e., format string)
# returns text to add to bash PS1 prompt (includes branch name)
__gitdir ()
{
  if [ -z "${1-}" ]; then
    if [ -n "${__git_dir-}" ]; then
      echo "$__git_dir"
    elif [ -d .git ]; then
      echo .git
    else
      git rev-parse --git-dir 2>/dev/null
    fi
  elif [ -d "$1/.git" ]; then
    echo "$1/.git"
  else
    echo "$1"
  fi
}
__git_ps1 ()
{
  local g="$(__gitdir)"
  if [ -n "$g" ]; then
    local r
    local b
    if [ -f "$g/rebase-merge/interactive" ]; then
      r="|REBASE-i"
      b="$(cat "$g/rebase-merge/head-name")"
    elif [ -d "$g/rebase-merge" ]; then
      r="|REBASE-m"
      b="$(cat "$g/rebase-merge/head-name")"
    else
      if [ -d "$g/rebase-apply" ]; then
        if [ -f "$g/rebase-apply/rebasing" ]; then
          r="|REBASE"
        elif [ -f "$g/rebase-apply/applying" ]; then
          r="|AM"
        else
          r="|AM/REBASE"
        fi
      elif [ -f "$g/MERGE_HEAD" ]; then
        r="|MERGING"
      elif [ -f "$g/BISECT_LOG" ]; then
        r="|BISECTING"
      fi

      b="$(git symbolic-ref HEAD 2>/dev/null)" || {

        b="$(
        case "${GIT_PS1_DESCRIBE_STYLE-}" in
        (contains)
          git describe --contains HEAD ;;
        (branch)
          git describe --contains --all HEAD ;;
        (describe)
          git describe HEAD ;;
        (* | default)
          git describe --exact-match HEAD ;;
        esac 2>/dev/null)" ||

        b="$(cut -c1-7 "$g/HEAD" 2>/dev/null)..." ||
        b="unknown"
        b="($b)"
      }
    fi

    local w
    local i
    local s
    local u
    local c

    if [ "true" = "$(git rev-parse --is-inside-git-dir 2>/dev/null)" ]; then
      if [ "true" = "$(git rev-parse --is-bare-repository 2>/dev/null)" ]; then
        c="BARE:"
      else
        b="GIT_DIR!"
      fi
    elif [ "true" = "$(git rev-parse --is-inside-work-tree 2>/dev/null)" ]; then
      if [ -n "${GIT_PS1_SHOWDIRTYSTATE-}" ]; then
        if [ "$(git config --bool bash.showDirtyState)" != "false" ]; then
          git diff --no-ext-diff --ignore-submodules \
            --quiet --exit-code || w="*"
          if git rev-parse --quiet --verify HEAD >/dev/null; then
            git diff-index --cached --quiet \
              --ignore-submodules HEAD -- || i="+"
          else
            i="#"
          fi
        fi
      fi
      if [ -n "${GIT_PS1_SHOWSTASHSTATE-}" ]; then
              git rev-parse --verify refs/stash >/dev/null 2>&1 && s="$"
      fi

      if [ -n "${GIT_PS1_SHOWUNTRACKEDFILES-}" ]; then
         if [ -n "$(git ls-files --others --exclude-standard)" ]; then
            u="%"
         fi
      fi
    fi

    if [ -n "${1-}" ]; then
      printf "$1" "$c${b##refs/heads/}$w$i$s$u$r"
    else
      printf " (%s)" "$c${b##refs/heads/}$w$i$s$u$r"
    fi
  fi
}


__git_branch_ps1 ()
{
   if [ -d ".git" ]; then
    echo " ($(git branch | egrep '\*' | cut -d ' ' -f2))"
   fi
}

export GIT_PS1_SHOWDIRTYSTATE=1 GIT_PS1_SHOWUNTRACKEDFILES=1 GIT_PS1_SHOWSTASHSTATE=1

# Set DEV_ENV and get a little nicer experience when moving between server environments
if [[ $DEV_ENV == "development" ]]; then # Meant for Local, standard slower but more info PS1
  export PS1='\[\033[0;37m\]\u:\[\033[0;33m\]\W\[\033[0m\]\[\033[1;32m\]$(__git_ps1)\[\033[0m\] \$ '
elif [[ $DEV_ENV == "staging" ]]; then # Staging box quicker load
  export PS1='\[\033[1;36m\]\u:\[\033[1;36m\]\W\[\033[0m\]\[\033[1;31m\]$(__git_branch_ps1)\[\033[0m\] \$ '
elif [[ $DEV_ENV == "production" ]]; then
  export PS1='\[\033[0;31m\]\u:\[\033[0;31m\]\W\[\033[0m\]\[\033[1;31m\]$(__git_branch_ps1)\[\033[0m\] \$ '
fi

# Hardcoded json with Accepts header piped to json beautifier
function u_a_json(){
 curl -H "Accept: application/services.v1" "$@" | python -mjson.tool
}

# tar zip as itself with extension info
function u_tar_zip(){
 tar -zcvf $1.tar.gz $1
}

# pull and push to current branch
function u_pap(){
  a="$(git branch | egrep '\*' | sed -n '/\* /s///p')"
  git pull --rebase origin $a && git push origin $a
}

# Convert psds to pngs in current directory
function convert_dir_psds_to_png(){
  for i in *.psd; do sips -s format png "${i}" --out "${i%psd}png"; done
}

# Display user functions
function u_functions(){
  declare -F | egrep -v git | sed 's/declare -f //' | sed 's/^[^u][a-z\_]*//' | sed '/^\s*$/d'
}

alias mem_size='du -sh'
alias grep='grep --color'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ngrep='fgrep -rn --color'
alias summary='git log --date=iso --author="Austin Flores" --summary --show-notes --oneline --date-order --since=`date -v"-1d" "+%Y-%m-%d"`'

alias dockerps='docker ps --format="table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}"'

# BEGIN CURRENT PROJECT
alias web='cd ~/ttt/web'
alias imports='cd ~/ttt/imports'
alias racleur='cd ~/perso/projets/racleur'
# END CURRENT PROJECT

# bundle shortcuts
alias be='bundle exec'

# Derp fix
alias sl=ls

# Quick Sudo
alias _="sudo"

source ~/git-completion.bash

export EDITOR=vim

# Load rbenv if it has ben installed
if [ -d "$HOME/.rbenv/bin" ]
then
 export PATH="$HOME/.rbenv/bin:$PATH"
 eval "$(rbenv init -)"
fi
