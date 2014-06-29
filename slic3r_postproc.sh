#!/bin/bash

# The Da Vinci is very picky about the comments and white-space in the g-code. This simple
# script will take a g-code file and modify it in-place to make it acceptable to the Da Vinci.

/usr/bin/sed -ne 's/filament used = \(.*\)mm.*/total_filament = \1/p' "$*" > "$*".new
/usr/bin/sed  '/^$/d' $* >> "$*".new
/bin/mv -f "$*".new "$*"

