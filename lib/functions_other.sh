#!/bin/bash
function check_if_installed
{
   local cmd=$1
   local is_installed=$(type -t $cmd | wc -l)
   if (( $is_installed )); then
      : # it is ok, do nothing
   else
      echo "ERROR: $cmd is not installed"
      echo "exiting"
      exit 1
   fi
}

function horn
{
   paplay "sounds/$HORN"
}

function get_logfilename
{
   local current_date="$(date +'%Y%m%d')"
   local logfile="${LOG_DIR}/${current_date}.log"
   mkdir -p ${LOG_DIR}
   touch $logfile
   echo $logfile
}

function log
{
   local current_time="$(date +'%H:%M')"
   printf "%s\t%s\n" "$current_time" "$1" >> $(get_logfilename)
}

function get_last_task
{
   tail -1 $(get_logfilename) | sed -e 's/.*:[ \t]*//'
}
