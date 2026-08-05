#!/bin/ksh
#
# User profile for OpenBSD
#
# See the LICENSE file at the top of the project tree for copyright
# and license details.

PATH=/sbin:/usr/sbin:/bin:/usr/bin:/usr/X11R6/bin:/usr/local/sbin:/usr/local/bin
export PATH

# Set HOSTNAME
if [ -z "${HOSTNAME:-}" ]; then
	HOSTNAME=$(uname -n)
fi
export HOSTNAME

# Pick prompt symbol
if [ "$(id -u)" -eq 0 ]; then
	PSCHAR='#'
else
	PSCHAR='$'
fi

# Prompt
export PS1='${LOGNAME}@${HOSTNAME%%.*}:${PWD} ${PSCHAR} '

# Locale and tools
export LANG='es_ES.UTF-8'
export LC_CTYPE='es_ES.UTF-8'
export LC_COLLATE='C'
export EDITOR=vi
export VISUAL=kak
export FCEDIT=$EDITOR
export PAGER=less
export LESS='-iMRS -x2'
export CLICOLOR=0

# History and editing mode
HISTFILE=$HOME/.ksh_history
HISTSIZE=20000
set -o vi

# Default umask
umask 022

# Only run this block for interactive shells
case "$-" in
*i*) # interactive shell
	if [ -x /usr/bin/tset ]; then
		eval "$(/usr/bin/tset -IsQ '-munknown:?vt220' "$TERM")"
	fi
	;;
esac
