#!/bin/bash

echo "Largest files:"
find . -printf '%s %p\n'|sort -nr|head

echo "Largest files and dirs"
du -a . | sort -nr | head
