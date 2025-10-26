#!/bin/bash

SESSION_NAME="monitor"

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

check_tools() {
    local missing_tools=()
    for tool in btop bandwhich ncdu lnav; do
        if ! command -v "$tool" &> /dev/null; then
            missing_tools+=("$tool")
        fi
    done

    if [ ${#missing_tools[@]} -gt 0 ]; then
        echo -e "${YELLOW}Warning: The following tools are not installed:${NC}"
        printf '  - %s\n' "${missing_tools[@]}"
        echo -e "${BLUE}Install with: brew install ${missing_tools[*]}${NC}"
        return 1
    fi
    return 0
}

tmux has-session -t "$SESSION_NAME" 2>/dev/null

if [ $? != 0 ]; then
    echo -e "${GREEN}Creating new tmux session: $SESSION_NAME${NC}"

    if ! check_tools; then
        echo -e "${YELLOW}Continuing anyway...${NC}"
    fi

    tmux new-session -d -s "$SESSION_NAME" -n "monitoring"
    tmux send-keys -t "$SESSION_NAME:1.1" "btop" C-m
    tmux split-window -t "$SESSION_NAME:1" -v -p 50
    tmux split-window -t "$SESSION_NAME:1.1" -h -p 50
    tmux split-window -t "$SESSION_NAME:1.3" -h -p 50
    tmux send-keys -t "$SESSION_NAME:1.2" "sudo bandwhich" C-m
    tmux send-keys -t "$SESSION_NAME:1.3" "ncdu ~" C-m
    tmux send-keys -t "$SESSION_NAME:1.4" "lnav /var/log/system.log" C-m
    tmux select-pane -t "$SESSION_NAME:1.1"

    echo "Monitor session created successfully!"
    echo "Attach with: tmux attach -t $SESSION_NAME"
    echo "Or switch to it from within tmux: Prefix + s"
else
    echo "Session '$SESSION_NAME' already exists."
fi

if [ -z "$TMUX" ]; then
    tmux attach -t "$SESSION_NAME"
else
    echo "Already in a tmux session. Switch with: Prefix + s"
fi

