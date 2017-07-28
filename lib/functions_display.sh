#!/bin/bash

export DISPLAY=:0


function zenity
{
    /usr/bin/zenity "$@" 2>/dev/null
}

function display_menu
{
	zenity --list --height=$WINDOW_HEIGHT --title=$WINDOW_TITLE --column "Menu" "$@"
}

function display_info
{
   zenity --info --text="$*"
}
