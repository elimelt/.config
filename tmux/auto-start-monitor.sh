#!/bin/bash

SESSION_NAME="monitor"

if ! command -v tmux &> /dev/null; then
    exit 0
fi

if ! tmux has-session -t "$SESSION_NAME" 2>/dev/null; then
    bash ~/.config/tmux/monitor-session.sh &
    disown
fi

