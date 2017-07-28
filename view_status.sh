#!/bin/bash
# view pomodoro status in one line. usefull for panel plugins or desktop applets
WD=${0%/*}
awk -v s="" '{s=s" "$0} END{print s}' $WD/status/state $WD/status/timer
