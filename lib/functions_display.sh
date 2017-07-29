#!/bin/bash

export DISPLAY=:0
TITLE="Pomodoro"


function zenity
{
    /usr/bin/zenity "$@" 2>/dev/null
}

function display_list
{
   local window_height=$(( 90 + ($# * 24) ))
	zenity --list --height=$window_height --title="$TITLE" --column "$@"
}

function display_info
{
   zenity --info --text="$*"
}

function display_entry
{
   zenity --entry --title="$TITLE" --text="$1" --entry-text="$2"
}
