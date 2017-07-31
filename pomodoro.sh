#!/bin/bash
if [ ! -f $(pwd)"/config" ]; then
	echo "ERROR: working directory is set to: $(pwd)"
	zenity --error --text="ERROR: working directory is set to: $(pwd)"
	exit
fi


source ./config
source lib/functions_display.sh
source lib/functions_status.sh
source lib/functions_other.sh

init_status_files
check_if_installed zenity

MENU_POMODORO="New Pomodoro"
MENU_SHORT_BREAK="Short Break"
MENU_LONG_BREAK="Long Break"
MENU_PAUSE="(Un)Pause"
MENU_CUSTOM_NAME="$CUSTOM_NAME"


function do_pomodoro
{
	if is_first_pomodoro_today; then
		set_status_date_today
		reset_status_counter
	fi
	set_state $STATE_POMODORO
	if [ "$1" == "" ]; then
		timer $POMODORO_DURATION
	else
		timer $1
	fi
	increment_status_counter

	local project=$(display_list "Select Project" "${PROJECTS[@]}")
	local task=$(display_entry "Enter task" "$(get_last_task)")
	log "${project}: ${task}"

}

function do_break
{
	check_if_small_nonzero_integer $1
	set_state $STATE_BREAK
	timer $1
	horn
}

function do_custom
{
	set_state $STATE_CUSTOM
	$CUSTOM_SCRIPT
}

function do_pause
{
	if is_paused; then
		# continue in paused pomodoro
		do_pomodoro $(( $(get_timer_minutes) + 1 ))
	elif is_pomodoro_running; then
		# pause pomodoro
		set_state $STATE_PAUSE
	else
		# only pomodoro can be pauses
		display_info "No running pomodoro"
	fi
}

function is_selected_menu_item
{
	local state=$(get_state)
	local count=$(get_status_counter)
	local radio="FALSE"
	case "$state" in
		"$STATE_POMODORO")
			if (( $count % 4 == 0)); then
				if [ "$1" == "$MENU_LONG_BREAK" ]; then
					radio=TRUE
				fi
			else
				if [ "$1" == "$MENU_SHORT_BREAK" ]; then
					radio=TRUE
				fi
			fi
		;;
		"$STATE_PAUSE")
			if [ "$1" == "$MENU_PAUSE" ]; then
				radio="TRUE"
			fi
		;;
		*)
			if [ "$1" == "$MENU_POMODORO" ]; then
				radio="TRUE"
			fi
		;;
	esac
	echo "$radio"
}

while true
do

	choice=$(display_radiolist "Menu" \
 					$(is_selected_menu_item "$MENU_POMODORO")    "$MENU_POMODORO"   \
					$(is_selected_menu_item "$MENU_SHORT_BREAK") "$MENU_SHORT_BREAK"\
					$(is_selected_menu_item "$MENU_LONG_BREAK")  "$MENU_LONG_BREAK" \
					$(is_selected_menu_item "$MENU_PAUSE")       "$MENU_PAUSE"      \
					$(is_selected_menu_item "$MENU_CUSTOM_NAME") "$MENU_CUSTOM_NAME")

	case "$choice" in
		"$MENU_POMODORO"       ) do_pomodoro ;;
		"$MENU_SHORT_BREAK"    ) do_break $SHORT_BREAK_DURATION ;;
		"$MENU_LONG_BREAK"     ) do_break $LONG_BREAK_DURATION ;;
		"$MENU_PAUSE"          ) do_pause ;;
		"$MENU_CUSTOM_NAME"    ) do_custom ;;
		*) break ;;
	esac


done
