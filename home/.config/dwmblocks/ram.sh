#!/bin/bash

ICON=""  

RAM=$(free | awk '/^Mem/ {printf "%d", $3/$2*100}')

echo "${ICON} ${RAM}%"
