#!/bin/bash
# Snapshot Creation Script for OpenClaw Workspace
# Manual tool for creating immutable snapshots via GitHub tags
# REQUIRES EXPLICIT USER CONFIRMATION AT EACH STEP

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
SNAPSHOTS_DIR="${WORKSPACE_DIR}/.snapshots"
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

# Check if in workspace directory
check_workspace() {
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

# Check git status
check_git_status() {
    print_header "Checking Git Status"

    log_info "Current branch:"
    git branch --show-current
    echo ""

    log_info "Uncommitted changes:"
    git status --short
    echo ""

    if [ -n "$(git status --porcelain)" ]; then
        log_warn "There are uncommitted changes"
        read -p "Continue anyway? (y/n): " continue_uncommitted
        if [ "$continue_uncommitted" != "y" ]; then
            log_error "Aborted"
            exit 1
        fi
    fi
}

# Get snapshot description
get_description() {
    print_header "Snapshot Description"

    echo "Enter a brief description for this snapshot:"
    echo "Examples: initial, github-ready, production-ready, before-experiment-x"
    echo ""

    while true; do
        read -p "Description (kebab-case): " description
        if [ -z "$description" ]; then
            log_error "Description cannot be empty"
            continue
        fi

        # Convert to kebab-case
        description=$(echo "$description" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
        break
    done

    # Generate snapshot name
    SNAPSHOT_DATE=$(date +%Y-%m-%d-%H%M)
    SNAPSHOT_NAME="snap-${SNAPSHOT_DATE}-${description}"

    echo ""
    log_info "Snapshot will be named: ${CYAN}${SNAPSHOT_NAME}${NC}"
    echo ""
}

# Get snapshot notes
get_notes() {
    print_header "Snapshot Notes"

    echo "Enter detailed notes about this snapshot (optional):"
    echo "Press Enter when done, or Ctrl+D on a new line:"
    echo ""

    notes=$(cat)

    if [ -z "$notes" ]; then
        notes="No additional notes"
    fi
    echo ""
}

# Generate snapshot message
generate_message() {
    print_header "Snapshot Message"

    # Gather system info
    current_date=$(date -u +"%Y-%m-%d %H:%M:%S UTC")

    # Count skills in workspace
    workspace_skills=$(find "${WORKSPACE_DIR}/skills" -maxdepth 1 -type d 2>/dev/null | tail -n +2 | wc -l)

    # Get hooks status
    hooks_count=$(openclaw hooks list 2>/dev/null | grep -c "ready" || echo "0")

    # Generate message
    cat > /tmp/snapshot_message.txt << EOF
[Snapshot Details]
Date: ${current_date}
Description: ${description}

[Configurations]
- GitHub: SSH configured, PAT set, gh CLI authenticated
- Skills (workspace): ${workspace_skills} skills
- Hooks: ${hooks_count} hooks enabled
- Git Identity: MIDIALIZANDO VPS <vps@smitti.dev>

[Snapshot Notes]
${notes}

[Files Modified]
$(git diff --name-only HEAD~5..HEAD 2>/dev/null || echo "See git log for details")

[Created By]
MIDIALIZANDO (VPS srv1169527)
Manual Snapshot Creation
EOF

    log_info "Snapshot message generated:"
    echo "----------------------------------------"
    cat /tmp/snapshot_message.txt
    echo "----------------------------------------"
    echo ""
}

# Confirm before proceeding
confirm_snapshot() {
    print_header "Confirmation"

    echo "You are about to create a snapshot:"
    echo "  Name: ${CYAN}${SNAPSHOT_NAME}${NC}"
    echo "  Description: ${description}"
    echo "  Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
    echo ""
    echo "${YELLOW}This will:${NC}"
    echo "  - Stage all changes in the workspace"
    echo "  - Create a commit with snapshot message"
    echo "  - Push to GitHub"
    echo "  - Create an immutable tag"
    echo "  - Push the tag to GitHub"
    echo ""
    echo "${RED}This CANNOT be undone (tags are immutable)!${NC}"
    echo ""

    read -p "Create snapshot? (type 'yes' to confirm): " confirm
    if [ "$confirm" != "yes" ]; then
        log_error "Aborted by user"
        exit 1
    fi

    echo ""
    log_success "Creating snapshot..."
    echo ""
}

# Create the snapshot
create_snapshot() {
    print_header "Creating Snapshot"

    # Stage all changes
    log_info "Staging all changes..."
    git add .

    # Commit
    log_info "Creating commit..."
    git commit -F /tmp/snapshot_message.txt
    log_success "Commit created"

    # Push to GitHub
    log_info "Pushing to GitHub..."
    git push origin main
    log_success "Pushed to main branch"

    # Create tag
    log_info "Creating tag: ${SNAPSHOT_NAME}..."
    git tag -a "${SNAPSHOT_NAME}" -m "Snapshot: ${description}" -m "$(cat /tmp/snapshot_message.txt)"
    log_success "Tag created locally"

    # Push tag
    log_info "Pushing tag to GitHub..."
    git push origin "${SNAPSHOT_NAME}"
    log_success "Tag pushed to GitHub"

    # Create metadata file
    log_info "Creating metadata file..."
    mkdir -p "${SNAPSHOTS_DIR}/${SNAPSHOT_NAME}"

    cat > "${SNAPSHOTS_DIR}/${SNAPSHOT_NAME}/metadata.md" << EOF
# Snapshot Metadata

## Information

**Snapshot ID:** ${SNAPSHOT_NAME}
**Date Created:** $(date -u +"%Y-%m-%d %H:%M:%S UTC")
**Description:** ${description}
**GitHub Tag:** ${GITHUB_REPO}/releases/tag/${SNAPSHOT_NAME}

## Notes

${notes}

## System Information

- Workspace: ${WORKSPACE_DIR}
- Git User: $(git config user.name) <$(git config user.email)>
- Branch: main
- Commit: $(git rev-parse HEAD)

## Files

- Total files committed: $(git ls-files | wc -l)
- Latest commit: $(git log -1 --pretty=format:"%h - %s")
EOF

    log_success "Metadata file created"
}

# Final summary
final_summary() {
    print_header "Snapshot Created Successfully"

    echo "Snapshot Details:"
    echo "  Name: ${CYAN}${SNAPSHOT_NAME}${NC}"
    echo "  GitHub: https://github.com/${GITHUB_REPO}/releases/tag/${SNAPSHOT_NAME}"
    echo "  Commit: $(git rev-parse HEAD)"
    echo "  Date: $(date -u +"%Y-%m-%d %H:%M:%S UTC")"
    echo ""
    echo "This snapshot is immutable and cannot be modified."
    echo "To restore this snapshot, use: ./snapshots-restore.sh ${SNAPSHOT_NAME}"
    echo ""
    log_success "Snapshot creation complete!"
}

# Main execution
main() {
    echo ""
    echo -e "${CYAN}╔══════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║   Snapshot Creation Tool - OpenClaw      ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════╝${NC}"
    echo ""

    check_workspace
    check_git_status
    get_description
    get_notes
    generate_message
    confirm_snapshot
    create_snapshot
    final_summary

    # Cleanup
    rm -f /tmp/snapshot_message.txt
}

# Run main function
main
