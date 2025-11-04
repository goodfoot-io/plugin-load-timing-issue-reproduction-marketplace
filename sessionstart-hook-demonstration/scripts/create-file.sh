#!/bin/bash

# Create SESSION_START_HOOK_COMPLETE file in working directory if it doesn't exist
if [ ! -f SESSION_START_HOOK_COMPLETE ]; then
    echo "SessionStart hook executed at $(date)" > SESSION_START_HOOK_COMPLETE
    echo "Created SESSION_START_HOOK_COMPLETE file in $(pwd)"
else
    echo "SESSION_START_HOOK_COMPLETE file already exists"
fi
