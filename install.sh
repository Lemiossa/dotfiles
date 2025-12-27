#!/bin/sh

set -e 

echo "Instalando configurações..."

mkdir -p "${HOME}"
cp -rv home/. "${HOME}/"

echo "Concluído."

