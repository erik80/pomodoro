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

function kill_other_instances
{
   echo "My pid is $$"
   ps -ef | grep pomodoro.sh | grep -v grep | grep -v atom | grep -v $$
}
