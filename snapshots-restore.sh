#!/bin/bash
# Snapshot Restore Script for OpenClaw Workspace
# Manual tool for restoring workspace to a snapshot state
# REQUIRES EXPLICIT USER CONFIRMATION

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

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
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
        log_warn "You are not in the workspace directory"
        log_info "Current: $(pwd)"
        log_info "Workspace: $WORKSPACE_DIR"
        echo ""
        read -p "Change to workspace directory? (y/n): " change_dir
        if [ "$change_dir" = "y" ]; then
            cd "$WORKSPACE_DIR" || exit 1
            log_success "Changed to workspace directory"
        else
            log_error "Aborted"
            exit 1
        fi
    fi
}

# Check for uncommitted changes
check_uncommitted() {
    print_header "Checking for Uncommitted Changes"

    log_info "Current git status:"
    git status --short
    echo ""

    if [ -n "$(git status --porcelain)" ]; then
        echo -e "${RED}═══════════════════════════════════════════${NC}"
        echo -e "${RED}WARNING: You have uncommitted changes!${NC}"
        echo -e "${RED}═══════════════════════════════════════════${NC}"
        echo ""
        log_warn "Restoring a snapshot will DESTROY all uncommitted changes!"
        echo ""
        echo "Your options:"
        echo "  1. Stash changes: git stash"
        echo "  2. Commit changes: git add . && git commit"
        echo "  3. Cancel restoration"
        echo ""
        read -p "How do you want to proceed? (1/2/3): " action

        case $action in
            1)
                log_info "Stashing changes..."
                git stash push -m "Auto-stash before snapshot restore"
                log_success "Changes stashed"
                ;;
            2)
                log_info "Committing changes..."
                git add .
                git commit -m "Auto-commit before snapshot restore"
                log_success "Changes committed"
                ;;
            3)
                log_error "Aborted by user"
                exit 1
                ;;
            *)
                log_error "Invalid choice"
                exit 1
                ;;
        esac
        echo ""
    else
        log_success "No uncommitted changes"
        echo ""
    fi
}

# Show snapshot details
show_snapshot_details() {
    print_header "Snapshot Details"

    log_info "Snapshot: ${CYAN}${SNAPSHOT_NAME}${NC}"
    echo ""

    # Show tag message
    echo -e "${BLUE}Snapshot message:${NC}"
    echo "----------------------------------------"
    git tag -l "$SNAPSHOT_NAME" -n9
    echo "----------------------------------------"
    echo ""

    # Show commit diff
    log_info "Changes from current HEAD:"
    echo ""
    git rev-list --oneline "HEAD...${SNAPSHOT_NAME}" | head -20
    echo ""
}

# Confirm restoration
confirm_restore() {
    print_header "RESTORATION WARNING"

    echo -e "${RED}═══════════════════════════════════════════${NC}"
    echo -e "${RED}CRITICAL WARNING: SNAPSHOT RESTORATION${NC}"
    echo -e "${RED}═══════════════════════════════════════════${NC}"
    echo ""
    echo "You are about to restore the workspace to:"
    echo -e "  Snapshot: ${CYAN}${SNAPSHOT_NAME}${NC}"
    echo ""
    echo -e "${RED}This will:${NC}"
    echo "  - Reset the entire workspace to the snapshot state"
    echo "  - DELETE all commits made after the snapshot"
    echo "  - DELETE all untracked files"
    echo "  - Lose all work done since the snapshot"
    echo "  - Require reinstalling skills if needed"
    echo ""
    echo -e "${RED}This CANNOT be undone (unless you create a new snapshot first)!${NC}"
    echo ""
    echo -e "${YELLOW}RECOMMENDATION:${NC}"
    echo "  Create a current snapshot first: ./snapshots-create.sh"
    echo ""
    echo -e "${RED}═══════════════════════════════════════════${NC}"
    echo ""

    read -p "Have you created a snapshot of the current state? (y/n): " created_snapshot

    if [ "$created_snapshot" != "y" ]; then
        log_warn "It's highly recommended to snapshot first"
        echo ""
        read -p "Continue anyway? (type 'yes' to confirm): " continue_anyway
        if [ "$continue_anyway" != "yes" ]; then
            log_error "Aborted by user"
            exit 1
        fi
    fi

    echo ""
    read -p "Restore snapshot '${SNAPSHOT_NAME}'? (type 'yes' to confirm): " confirm
    if [ "$confirm" != "yes" ]; then
        log_error "Aborted by user"
        exit 1
    fi

    echo ""
    log_success "Restoring snapshot..."
    echo ""
}

# Perform restoration
restore_snapshot() {
    print_header "Restoring Snapshot"

    # Fetch tags
    log_info "Fetching tags from GitHub..."
    git fetch --tags --quiet
    log_success "Tags fetched"

    # Check if tag exists
    if ! git tag -l "$SNAPSHOT_NAME" | grep -q "$SNAPSHOT_NAME"; then
        log_error "Snapshot not found: $SNAPSHOT_NAME"
        echo ""
        echo "Available snapshots:"
        git tag -l "snap-*"
        exit 1
    fi

    # Reset to snapshot
    log_info "Resetting workspace to snapshot..."
    git reset --hard "$SNAPSHOT_NAME"
    log_success "Workspace reset to snapshot"

    # Force push to main (update remote)
    log_info "Pushing restored state to GitHub..."
    git push origin main --force
    log_success "Remote updated"

    echo ""
    log_success "Snapshot restored successfully!"
}

# Post-restore instructions
post_restore() {
    print_header "Post-Restoration Instructions"

    echo "The workspace has been restored to: ${CYAN}${SNAPSHOT_NAME}${NC}"
    echo ""
    echo "Recommended post-restore steps:"
    echo ""
    echo "1. Verify workspace state:"
    echo "   git status"
    echo ""
    echo "2. Check installed skills:"
    echo "   ls skills/"
    echo ""
    echo "3. Reinstall skills if needed:"
    echo "   clawhub list"
    echo "   clawhub install <skill-name>"
    echo ""
    echo "4. Re-enable hooks if needed:"
    echo "   openclaw hooks list"
    echo "   openclaw hooks enable <hook-name>"
    echo ""
    echo "5. Restart OpenClaw Gateway if needed:"
    echo "   openclaw gateway restart"
    echo ""
    echo "6. Test critical functionality"
    echo ""

    # Check if skills need reinstallation
    workspace_skills=$(find "${WORKSPACE_DIR}/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)
    if [ "$workspace_skills" -gt 0 ]; then
        log_info "Found $workspace_skills skill(s) in workspace"
        echo "These may need reinstallation if they use executables or system integration"
    fi
}

# Final summary
final_summary() {
    print_header "Restoration Complete"

    echo "Snapshot Details:"
    echo "  Restored to: ${CYAN}${SNAPSHOT_NAME}${NC}"
    echo "  Commit: $(git rev-parse HEAD)"
    echo "  Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
    echo "  GitHub: https://github.com/${GITHUB_REPO}/releases/tag/${SNAPSHOT_NAME}"
    echo ""
    log_success "Workspace restored to snapshot state!"
    echo ""
    echo "To create a new snapshot from this state: ./snapshots-create.sh"
}

# Main execution
main() {
    SNAPSHOT_NAME="$1"

    if [ -z "$SNAPSHOT_NAME" ]; then
        echo ""
        echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
        echo -e "${CYAN}║   Snapshot Restore Tool - OpenClaw        ║${NC}"
        echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
        echo ""
        echo "Usage: $0 <snapshot-name>"
        echo ""
        echo "Example:"
        echo "  $0 snap-2026-02-03-initial"
        echo ""
        echo "List available snapshots:"
        echo "  ./snapshots-list.sh"
        exit 1
    fi

    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   Snapshot Restore Tool - OpenClaw        ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""

    change_to_workspace
    check_uncommitted
    show_snapshot_details
    confirm_restore
    restore_snapshot
    post_restore
    final_summary
}

# Run main function
main "$@"
