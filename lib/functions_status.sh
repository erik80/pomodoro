#!/bin/bash

STATUS_DATE_FILE="status/date"
STATUS_TIMER_FILE="status/timer"
STATUS_COUNTER_FILE="status/counter"
STATUS_STATE_FILE="status/state"

STATE_NEW_POMODORO="Pomodoro"
STATE_BREAK="Break"
STATE_PAUSE_CONTINUE="Pause/Continue"
STATE_CUSTOM="$CUSTOM_NAME"


function init_status_files
{
	mkdir -p status
	touch $STATUS_DATE_FILE
	touch $STATUS_TIMER_FILE
	touch $STATUS_COUNTER_FILE
	touch $STATUS_STATE_FILE
}

function is_first_pomodoro_today
{
	system_date=$(date +'%Y%m%d')
	status_date=$(<$STATUS_DATE_FILE)
	test  -n "$status_date" -a "$system_date" != "$status_date"
}

function set_status_date_today
{
	date +'%Y%m%d' > $STATUS_DATE_FILE
}

function increment_status_counter
{
	cnt=$(<$STATUS_COUNTER_FILE)
	cnt=$(( cnt + 1 ))
	echo $cnt > $STATUS_COUNTER_FILE
}

function reset_status_counter
{
	echo 0 > $STATUS_COUNTER_FILE
}

function set_state
{
	if [ "$1" = "$STATE_NEW_POMODORO" -o   \
	     "$1" = "$STATE_BREAK" -o          \
		  "$1" = "$STATE_PAUSE_CONTINUE" -o \
		  "$1" = "$STATE_CUSTOM"            ];
	then
		echo $1 > $STATUS_STATE_FILE
	else
		echo "ERROR: unknow state $1"
	fi
}

function get_state
{
	echo $(<$STATUS_STATE_FILE)
}
