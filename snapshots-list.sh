#!/bin/bash
# Snapshot List Script for OpenClaw Workspace
# Manual tool for listing available snapshots

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Configuration
WORKSPACE_DIR="/root/.openclaw/workspace"
GITHUB_REPO="Smitti7971/openclaw-workspace"

# Print functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo ""
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

# Change to workspace
change_to_workspace() {
    if [ "$(pwd)" != "$WORKSPACE_DIR" ]; then
        cd "$WORKSPACE_DIR" || exit 1
    fi
}

# Fetch latest tags
fetch_tags() {
    print_header "Fetching Snapshots"

    log_info "Fetching tags from GitHub..."
    git fetch --tags --quiet
    log_success "Tags fetched"
}

# List snapshots
list_snapshots() {
    print_header "Available Snapshots"

    # Get snapshot tags
    snapshots=$(git tag -l "snap-*" --sort=-creatordate)

    if [ -z "$snapshots" ]; then
        log_warn "No snapshots found"
        echo ""
        echo "Create your first snapshot with: ./snapshots-create.sh"
        exit 0
    fi

    # Display snapshots
    echo ""
    echo -e "${CYAN}Snapshots (newest first):${NC}"
    echo ""
    echo -e "${GREEN}┌─────────────────────────────────────────────────────────┐${NC}"
    printf "${GREEN}│${NC} %-45s ${GREEN}│${NC}\n" "SNAPSHOT NAME"
    echo -e "${GREEN}├─────────────────────────────────────────────────────────┤${NC}"

    snapshot_count=0
    while IFS= read -r snapshot; do
        snapshot_count=$((snapshot_count + 1))

        # Get date and message
        date=$(git log -1 --format=%ci "$snapshot" | cut -d' ' -f1-2)
        message=$(git tag -l "$snapshot" --format='%(contents:subject)')

        printf "${GREEN}│${NC} ${CYAN}%-45s${NC} ${GREEN}│${NC}\n" "$snapshot"
        printf "${GREEN}│${NC} Date: %-40s ${GREEN}│${NC}\n" "$date"
        printf "${GREEN}│${NC} Desc: %-40s ${GREEN}│${NC}\n" "${message:0:40}"
        printf "${GREEN}│${NC} URL:  https://github.com/${GITHUB_REPO}/releases/tag/${snapshot} ${GREEN}│${NC}"

        if [ $snapshot_count -lt $(echo "$snapshots" | wc -l) ]; then
            printf "${GREEN}├─────────────────────────────────────────────────────────┤${NC}"
        fi
        echo ""
    done <<< "$snapshots"

    echo -e "${GREEN}└─────────────────────────────────────────────────────────┘${NC}"
    echo ""
    echo "Total snapshots: ${CYAN}${snapshot_count}${NC}"
}

# Show snapshot details
show_details() {
    print_header "Snapshot Details"

    if [ -z "$1" ]; then
        log_info "To see details of a specific snapshot:"
        echo "  $0 <snapshot-name>"
        echo ""
        echo "Example:"
        echo "  $0 snap-2026-02-03-initial"
        exit 0
    fi

    snapshot="$1"

    # Check if snapshot exists
    if ! git tag -l "$snapshot" | grep -q "$snapshot"; then
        log_error "Snapshot not found: $snapshot"
        echo ""
        echo "Available snapshots:"
        git tag -l "snap-*"
        exit 1
    fi

    # Show details
    echo -e "${CYAN}Snapshot: ${snapshot}${NC}"
    echo ""

    # Show tag message
    log_info "Snapshot message:"
    echo ""
    git tag -l "$snapshot" -n99
    echo ""

    # Show commit details
    log_info "Commit details:"
    echo ""
    git show "$snapshot" --stat
    echo ""

    # Show files changed
    log_info "Files in snapshot:"
    echo ""
    git ls-tree -r --name-only "$snapshot" | head -20
    total_files=$(git ls-tree -r "$snapshot" | wc -l)
    echo "... and $((total_files - 20)) more files"
    echo ""
}

# Main execution
main() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   Snapshot List Tool - OpenClaw          ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""

    change_to_workspace
    fetch_tags

    if [ -n "$1" ]; then
        show_details "$1"
    else
        list_snapshots
    fi
}

# Run main function
main "$@"
