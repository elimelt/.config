#!/bin/bash

BOLD='\033[1m'
BLUE='\033[1;34m'
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
CYAN='\033[1;36m'
MAGENTA='\033[1;35m'
RED='\033[1;31m'
RESET='\033[0m'

clear
echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════════════════════════════╗${RESET}"
echo -e "${BOLD}${BLUE}║                        TMUX KEY BINDINGS CHEATSHEET                        ║${RESET}"
echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════════════════════════════════╝${RESET}"
echo ""
echo -e "${YELLOW}Prefix key: ${GREEN}Ctrl-a${RESET}"
echo ""

print_section() {
    echo -e "${BOLD}${CYAN}▶ $1${RESET}"
    echo -e "${CYAN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
}

print_binding() {
    printf "  ${GREEN}%-25s${RESET} %s\n" "$1" "$2"
}

print_section "GENERAL"
print_binding "Prefix + ?" "Show this cheatsheet"
print_binding "Prefix + r" "Reload configuration"
print_binding "Prefix + :" "Enter command mode"
print_binding "Prefix + t" "Show clock"
print_binding "Prefix + T" "Toggle status bar"
print_binding "Prefix + d" "Detach from session"
echo ""

print_section "SESSION MANAGEMENT"
print_binding "Prefix + s" "List and switch sessions (tree view)"
print_binding "Prefix + M" "Open/switch to monitor session"
print_binding "Prefix + N" "Create new session (prompted for name)"
print_binding "Prefix + R" "Rename current session"
print_binding "Prefix + Ctrl-j" "Switch to next session"
print_binding "Prefix + Ctrl-k" "Switch to previous session"
print_binding "Prefix + $" "Rename session"
echo ""

print_section "WINDOW MANAGEMENT"
print_binding "Prefix + c" "Create new window (in current path)"
print_binding "Prefix + ," "Rename current window"
print_binding "Prefix + w" "List windows"
print_binding "Prefix + n" "Next window"
print_binding "Prefix + p" "Previous window"
print_binding "Prefix + 0-9" "Switch to window by number"
print_binding "Alt + 1-9" "Quick switch to window 1-9 (no prefix)"
print_binding "Prefix + Ctrl-h" "Move to previous window (repeatable)"
print_binding "Prefix + Ctrl-l" "Move to next window (repeatable)"
print_binding "Prefix + Ctrl-Shift-Left" "Swap window left"
print_binding "Prefix + Ctrl-Shift-Right" "Swap window right"
print_binding "Prefix + &" "Kill current window (with confirmation)"
print_binding "Prefix + X" "Kill current window (no confirmation)"
print_binding "Prefix + f" "Find window by name"
echo ""

print_section "PANE MANAGEMENT"
print_binding "Prefix + | or \\" "Split pane horizontally"
print_binding "Prefix + - or _" "Split pane vertically"
print_binding "Prefix + h/j/k/l" "Navigate panes (vim-style)"
print_binding "Prefix + H/J/K/L" "Resize pane (repeatable, 5 cells)"
print_binding "Prefix + >" "Swap pane down"
print_binding "Prefix + <" "Swap pane up"
print_binding "Prefix + z" "Toggle pane zoom (fullscreen)"
print_binding "Prefix + b" "Break pane into new window"
print_binding "Prefix + @" "Join pane from another window"
print_binding "Prefix + x" "Kill current pane (no confirmation)"
print_binding "Prefix + !" "Break pane to new window"
print_binding "Prefix + q" "Show pane numbers"
print_binding "Prefix + o" "Cycle through panes"
print_binding "Prefix + {" "Move pane left"
print_binding "Prefix + }" "Move pane right"
print_binding "Prefix + Space" "Toggle pane layouts"
print_binding "Prefix + S" "Toggle pane synchronization"
echo ""

print_section "LAYOUTS"
print_binding "Prefix + Alt-1" "Even horizontal layout"
print_binding "Prefix + Alt-2" "Even vertical layout"
print_binding "Prefix + Alt-3" "Main horizontal layout"
print_binding "Prefix + Alt-4" "Main vertical layout"
print_binding "Prefix + Alt-5" "Tiled layout"
echo ""

print_section "COPY MODE"
print_binding "Prefix + [" "Enter copy mode"
print_binding "Prefix + Escape" "Enter copy mode"
print_binding "Prefix + ]" "Paste buffer"
print_binding "Prefix + P" "Choose from paste buffer list"
echo ""
echo -e "${MAGENTA}  Copy Mode Navigation (vim-style):${RESET}"
print_binding "  v" "Begin selection"
print_binding "  Ctrl-v" "Rectangle selection toggle"
print_binding "  y" "Copy selection and exit"
print_binding "  Y" "Copy entire line"
print_binding "  /" "Search forward"
print_binding "  ?" "Search backward"
print_binding "  h/j/k/l" "Move cursor"
print_binding "  w/b" "Move word forward/backward"
print_binding "  0/$" "Move to start/end of line"
print_binding "  g/G" "Move to top/bottom"
print_binding "  Ctrl-d/Ctrl-u" "Scroll half page down/up"
print_binding "  q" "Exit copy mode"
echo ""

print_section "MOUSE SUPPORT"
print_binding "Click" "Select pane"
print_binding "Drag border" "Resize pane"
print_binding "Drag status" "Reorder windows"
print_binding "Double-click" "Select word and copy"
print_binding "Triple-click" "Select line and copy"
print_binding "Scroll" "Scroll through history"
echo ""

print_section "MISCELLANEOUS"
print_binding "Prefix + Ctrl-l" "Clear screen and history"
print_binding "Prefix + i" "Display pane info"
print_binding "Prefix + ~" "Show messages"
print_binding "Prefix + Ctrl-a" "Send Ctrl-a to application"
echo ""

echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo -e "${YELLOW}Tip:${RESET} Press ${GREEN}q${RESET} or ${GREEN}Escape${RESET} to close this cheatsheet"
echo -e "${YELLOW}Config:${RESET} ~/.config/.tmux.conf"
echo -e "${BOLD}${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${RESET}"
echo ""

read -n 1 -s -r -p "Press any key to close..."

