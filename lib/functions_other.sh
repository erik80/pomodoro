#!/bin/bash
function check_if_installed
{
   cmd=$1
   is_installed=$(type -t $cmd | wc -l)
   if (( $is_installed )); then
      : # it is ok, do nothing
   else
      echo "ERROR: $cmd is not installed"
      echo "exiting"
      exit 1
   fi
}

function check_if_running
{
   cmd=${1##*/}
   ps -ef | grep $cmd | grep bash | grep -v $$ | grep -v atom | wc -l
}

function check_if_small_nonzero_integer
{
   if (($1>0 && $1<60)); then
		: # ok, argument is timer in minutes
	else
      echo "ERROR: value should be between 1-59"
		exit 1
	fi
}

function timer
{
   check_if_small_nonzero_integer $1
	timeout=$((60*$1))
	while [ $timeout -gt 0 ]
	do
		mins=$(($timeout/60))
		secs=$(($timeout-(60*$mins)))
		printf "%02d:%02d\n" "$mins" "$secs"
		sleep 1
		timeout=$(($timeout-1))
	done
}
