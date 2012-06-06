autoload -U compinit promptinit
autoload -U colors && colors
autoload -Uz vcs_info

compinit
promptinit

precmd () {
  if [[ -z $(git ls-files --other --exclude-standard 2> /dev/null) ]] {
		zstyle ':vcs_info:*' formats ' %F{green}(%F{blue}%b%c%u%F{green})'
  } else {
		zstyle ':vcs_info:*' formats  ' %F{green}(%F{red}%b%c%u%F{red}+%F{green})'
	}
	vcs_info
}

setopt completealiases
setopt correct
setopt auto_cd
setopt multios
setopt GLOB_COMPLETE
setopt share_history
setopt APPEND_HISTORY
setopt prompt_subst
unsetopt promptcr

bindkey "\e[7~" beginning-of-line # Home
bindkey "\e[8~" end-of-line # End

bindkey "^[[A" history-search-backward
bindkey "^[[B" history-search-forward

# vi keybindings
bindkey -v
bindkey -M vicmd "g~" vi-oper-swap-case

zstyle ':completion:*' menu select

# allow approximate
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir
zstyle ':completion:*:cd:*' ignore-parents parent pwd

zstyle ':vcs_info:*' stagedstr  '%F{28}+'
zstyle ':vcs_info:*' unstagedstr  '%F{11}+'
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:(sv[nk]|bzr):*' branchformat '%b%F{1}:%F{11}%r'
zstyle ':vcs_info:*' enable git svn

PROMPT='%{%F{red}%}[%{%F{blue}%}%c%{%F{red}%}]%{%f%}${vcs_info_msg_0_}%F{blue} %(?/%F{blue}/%F{red})% %{$reset_color%}'

export PAGER=~/my_bin/vimpager
export HISTSIZE=1000
export SAVEHIST=1000
export HISTFILE=~/.history

alias averages='awk -f '~/my_bin/avg.awk''
alias music='urxvtc -T "music" -e /home/rennis250/my_bin/music &'
alias mutt='urxvtc -T "mutt" -e mutt &'
alias calendar='urxvtc -T "calendar" -e /home/rennis250/my_bin/calendar &'
alias htop='urxvtc -T "monitors" -e htop &'
alias urxvt='urxvtc'
alias addevent='gcalcli quick'
alias shutdown='sudo shutdown -hP now'
alias reboot='sudo reboot'
alias open='ranger'
alias usb_mount='sudo mount -t vfat /dev/sdb1 /mnt/usbstick'
alias usb_remove='sudo umount /mnt/usbstick'
alias backup='unison -batch -perms 0'
alias news='urxvtc -T "news" -e newsbeuter &'
alias doc_open='vim --remote-tab-silent'
alias vim_server='urxvtc -T "doc edit" -e vim --servername VIM &'
alias gnuplot='urxvtc -T "gnuplot_term" -e gnuplot &'
alias skype='skype &'
alias lastfm='lastfm &'
alias office='libreoffice &'
alias readpdf='zathura'
alias laeqed='java -jar ~/my_bin/Laeqed.jar &'
alias oFproject='python2 ~/openFrameworks/scripts/linux/createProjects.py'
alias r_proj='R --quiet --no-save --no-restore'
alias mddia='/home/rennis250/my_bin/mddia/mddia'
alias gitbox='/home/rennis250/Dropbox/GitBox/gitbox.sh'
alias git_backup='/home/rennis250/Dropbox/GitBox/git_backup.sh'
alias nc='nc.openbsd'
alias octave='/opt/bin/octave'
alias matlab='/usr/local/MATLAB/R2012a/bin/matlab'
alias less=$PAGER
alias zless=$PAGER 
alias a='ag'
alias cl='clear'
alias m='mv'
alias v='vim'
alias c='cd'
alias l='ls++'

psg () {
	for i
	do ps axu | ag $i
	done
}

redisplay() {
   builtin zle .redisplay
   ( true ; show_mode "INSERT") &!
}
redisplay2() {
   builtin zle .redisplay
   (true ; show_mode "NORMAL") &!
}
zle -N redisplay
zle -N redisplay2
bindkey -M viins "^X^R" redisplay
bindkey -M vicmd "^X^R" redisplay2

screenclear () {
   echo -n "\033[2J\033[400H"
   builtin zle .redisplay
   (true ; show_mode "INSERT") &!
}
zle -N screenclear
bindkey "" screenclear

screenclearx () {
   repeat 2 print 
   local MYLINE="$LBUFFER$RBUFFER"
   highlight $MYLINE
   repeat 4 print 
   builtin zle redisplay
}
zle -N screenclearx
bindkey "^Xl" screenclearx

show_mode() {
   local COL
   local x
   COL=$[COLUMNS-3]
   COL=$[COL-$#1]
   x=$(echo $PREBUFFER | wc -l )
   x=$[x+1]
   echo -n "7[$x;A[0;G"
   echo -n ""
   echo -n "[0;37;44m--$1--[0m"
   echo -n "8"
}

zmodload zsh/parameter

###       vi-add-eol (unbound) (A) (unbound)
###              Move  to the end of the line and enter insert mode.

vi-add-eol() {
   show_mode "INSERT"
   builtin zle .vi-add-eol
}
zle -N vi-add-eol
bindkey -M vicmd "A" vi-add-eol

###       vi-add-next (unbound) (a) (unbound)
###              Enter insert mode after the  current  cursor  posi­
###              tion, without changing lines.
vi-add-next() {
   show_mode "INSERT"
   builtin zle .vi-add-next
   # OLDLBUFFER=$LBUFFER
   # OLDRBUFFER=$RBUFFER
   # NNUMERIC=$NUMERIC
   # bindkey -M viins "" vi-cmd-mode-a
}
zle -N vi-add-next
bindkey -M vicmd "a" vi-add-next


###       vi-change (unbound) (c) (unbound)
###              Read a movement command from the keyboard, and kill
###              from  the  cursor  position  to the endpoint of the
###              movement.  Then enter insert mode.  If the  command
###              is vi-change, change the current line.

vi-change() {
   show_mode "INSERT"
   builtin zle .vi-change
}
zle -N vi-change
bindkey -M vicmd "c" vi-change

###       vi-change-eol (unbound) (C) (unbound)
###              Kill  to the end of the line and enter insert mode.

vi-change-eol() {
   show_mode "INSERT"
   builtin zle .vi-change-eol
}
zle -N vi-change-eol
bindkey -M vicmd "C" vi-change-eol

###       vi-change-whole-line (unbound) (S) (unbound)
###              Kill the current line and enter insert mode.

vi-change-whole-line() {
   show_mode "INSERT"
   builtin zle .vi-change-whole-line
}
zle -N vi-change-whole-line
bindkey -M vicmd "S" vi-change-whole-line

###       vi-insert (unbound) (i) (unbound)
###              Enter insert mode.

vi-insert() {
   show_mode "INSERT"
   builtin zle .vi-insert
}
zle -N vi-insert
bindkey -M vicmd "i" vi-insert

###       vi-insert-bol (unbound) (I) (unbound)
###              Move to the first non-blank character on  the  line
###              and enter insert mode.

vi-insert-bol() {
   show_mode "INSERT"
   builtin zle .vi-insert-bol
}
zle -N vi-insert-bol
bindkey -M vicmd "I" vi-insert-bol

###       vi-open-line-above (unbound) (O) (unbound)
###              Open a line above the cursor and enter insert mode.

vi-open-line-above() {
   show_mode "INSERT"
   builtin zle .vi-open-line-above
}
zle -N vi-open-line-above
bindkey -M vicmd "O" vi-open-line-above

###       vi-open-line-below (unbound) (o) (unbound)
###              Open a line below the cursor and enter insert mode.

vi-open-line-below() {
   show_mode "INSERT"
   builtin zle .vi-open-line-below
}
zle -N vi-open-line-below
bindkey -M vicmd "o" vi-open-line-below

###       vi-substitute (unbound) (s) (unbound)
###              Substitute the next character(s).

vi-substitute() {
   show_mode "INSERT"
   builtin zle .vi-substitute
}
zle -N vi-substitute
bindkey -M vicmd "s" vi-substitute


###       vi-replace (unbound) (R) (unbound)
###              Enter overwrite mode.
###

vi-replace() {
   show_mode "REPLACE"
   builtin zle .vi-replace
}
zle -N vi-replace
bindkey -M vicmd "R" vi-replace

###       vi-cmd-mode (^X^V) (unbound) (^[)
###              Enter  command  mode;  that  is, select the `vicmd'
###              keymap.  Yes, this is bound  by  default  in  emacs
###              mode.

vi-cmd-mode() {
   show_mode "NORMAL"
   builtin zle .vi-cmd-mode
}
#zle -N vi-cmd-mode
bindkey -M viins "" vi-cmd-mode

source ~/.zsh/zsh-history-substring-search.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlight/zsh-syntax-highlighting.zsh
