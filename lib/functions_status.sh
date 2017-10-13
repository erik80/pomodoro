#!/bin/bash

STATUS_DATE_FILE="status/date"
STATUS_TIMER_FILE="status/timer"
STATUS_COUNTER_FILE="status/counter"
STATUS_STATE_FILE="status/state"

STATE_POMODORO="Pomodoro"
STATE_BREAK="Break"
STATE_PAUSE="Paused"
STATE_CUSTOM="Custom"


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
	local system_date=$(date +'%Y%m%d')
	local status_date=$(<$STATUS_DATE_FILE)
	test -n "$status_date" -a "$system_date" != "$status_date"
}

function is_paused
{
	local state=$(<$STATUS_STATE_FILE)
	test -n "$state" -a "$state" == $STATE_PAUSE
}

function is_pomodoro_state
{
	local state=$(<$STATUS_STATE_FILE)
	test -n "$state" -a "$state" == $STATE_POMODORO
}

function set_status_date_today
{
	date +'%Y%m%d' > $STATUS_DATE_FILE
}

function increment_status_counter
{
	local cnt=$(<$STATUS_COUNTER_FILE)
	local cnt=$(( cnt + 1 ))
	echo $cnt > $STATUS_COUNTER_FILE
}

function reset_status_counter
{
	echo 0 > $STATUS_COUNTER_FILE
}

function get_status_counter
{
	echo $(<$STATUS_COUNTER_FILE)
}

function set_state
{
	if [ "$1" = "$STATE_POMODORO" -o       \
	     "$1" = "$STATE_BREAK" -o          \
		  "$1" = "$STATE_PAUSE" -o          \
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

function check_if_small_nonzero_integer
{
   if (($1>0 && $1<60)); then
		: # ok, argument is timer in minutes
	else
      echo "ERROR: value should be between 1-59: $1"
		exit 1
	fi
}

function timer
{
   check_if_small_nonzero_integer $1
	local timeout=$((60*$1))
	while [ $timeout -gt 0 ]
	do
		local mins=$(($timeout/60))
		local secs=$(($timeout-(60*$mins)))
		printf "%02d:%02d\n" "$mins" "$secs" > $STATUS_TIMER_FILE
		sleep 1
		local timeout=$(($timeout-1))
		if is_paused; then
			exit 0
		fi
	done
}

function get_timer_minutes
{
	echo $(sed -e 's/:.*//' -e 's/^0*//' $STATUS_TIMER_FILE)
}
