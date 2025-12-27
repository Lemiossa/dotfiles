#!/bin/bash

ICON=""

DISK=$(df / | awk 'NR==2 {print int($3/$2*100)}')

echo "${ICON} ${DISK}%"
