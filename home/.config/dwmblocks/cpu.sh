#!/bin/bash

ICON=""

CPU=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print int(usage)}')

echo "${ICON} ${CPU}%"
