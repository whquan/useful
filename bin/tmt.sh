#!/bin/bash
# run terminator background
# block standard output AND standard error output
# -f: full screen
terminator -f >/dev/null 2>&1 &
