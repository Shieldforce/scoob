#!/bin/bash

if docker ps | grep "$2" &> /dev/null; then docker stop "$2" && docker image rm "$2" --force; else echo "error"; fi