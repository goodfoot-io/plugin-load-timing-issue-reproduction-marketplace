#!/bin/bash

# Create SESSION_START_HOOK_COMPLETE file in workspace if it doesn't exist
if [ ! -f /workspace/SESSION_START_HOOK_COMPLETE ]; then
    echo "SessionStart hook executed at $(date)" > /workspace/SESSION_START_HOOK_COMPLETE
    echo "Created SESSION_START_HOOK_COMPLETE file"
else
    echo "SESSION_START_HOOK_COMPLETE file already exists"
fi
