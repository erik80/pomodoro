#!/bin/bash
source ./config
source lib/functions_display.sh
source lib/functions_status.sh
source lib/functions_other.sh

init_status_files
check_if_installed zenity
#check_if_running $0

MENU_NEW_POMODORO="New Pomodoro"
MENU_SHORT_BREAK="Short Break"
MENU_LONG_BREAK="Long Break"
MENU_PAUSE_CONTINUE="Pause/Continue"
MENU_CUSTOM_NAME="$CUSTOM_NAME"


function start_new_pomodoro
{
	if is_first_pomodoro_today; then
		set_status_date_today
		reset_status_counter
	fi
	set_state $STATE_NEW_POMODORO
	timer $POMODORO_DURATION
	increment_status_counter
}

function start_break
{
	check_if_small_nonzero_integer $1
	set_state $STATE_BREAK
	timer $1
}

function start_custom
{
	set_state $STATE_CUSTOM
	$CUSTOM_SCRIPT
}

function start_pause_continue
{
	echo "TODO"
}

while true
do

	choice=$(display_menu "$MENU_NEW_POMODORO"       \
								 "$MENU_SHORT_BREAK"        \
								 "$MENU_LONG_BREAK"         \
								 "$MENU_PAUSE_CONTINUE"     \
								 "$MENU_CUSTOM_NAME"        )

	case "$choice" in
		"$MENU_NEW_POMODORO"   ) start_new_pomodoro ;;
		"$MENU_SHORT_BREAK"    ) start_break $SHORT_BREAK_DURATION ;;
		"$MENU_LONG_BREAK"     ) start_break $LONG_BREAK_DURATION ;;
		"$MENU_PAUSE_CONTINUE" ) start_pause_continue ;;
		"$MENU_CUSTOM_NAME"    ) start_custom ;;
		*) break ;;
	esac


done
