# TOOLS.md - Local Notes

Skills define _how_ tools work. This file is for _your_ specifics — the stuff that's unique to your setup.

## What Goes Here

Things like:

- Camera names and locations
- SSH hosts and aliases
- Preferred voices for TTS
- Speaker/room names
- Device nicknames
- Anything environment-specific

## Examples

```markdown
### Cameras

- living-room → Main area, 180° wide angle
- front-door → Entrance, motion-triggered

### SSH

- home-server → 192.168.1.100, user: admin

### TTS

- Preferred voice: "Nova" (warm, slightly British)
- Default speaker: Kitchen HomePod
```

## Why Separate?

Skills are shared. Your setup is yours. Keeping them apart means you can update skills without losing your notes, and share skills without leaking your infrastructure.

---

Add whatever helps you do your job. This is your cheat sheet.

---

## Nginx

### Reverse Proxy Configuration
- **Status:** ✅ Active and running
- **Version:** 1.24.0 (Ubuntu)
- **Directory:** /etc/nginx/

### Configured Subdomains
- n8n.smitti.midializando.cloud → localhost:5678
- chatwoot.smitti.midializando.cloud → localhost:3000

### Important Commands
```bash
# Reload configuration
systemctl reload nginx

# Test configuration
nginx -t

# View error logs
tail -f /var/log/nginx/error.log

# View access logs
tail -f /var/log/nginx/access.log

# Restart service
systemctl restart nginx
```

### Configuration Files
- n8n: /etc/nginx/sites-available/n8n.smitti.midializando.cloud
- Chatwoot: /etc/nginx/sites-available/chatwoot.smitti.midializando.cloud

---

## VPS Configuration

### Hostname
- **Name:** srv1169527
- **User:** root
- **Type:** Production VPS
- **Configured:** 2026-02-03

---

## GitHub

### Authentication
- **Account:** Smitti7971
- **SSH Key:** ~/.ssh/id_ed25519 (ed25519)
- **SSH Agent:** Configured and running
- **gh CLI:** Installed v2.45.0, authenticated via PAT
- **Status:** ✅ APTO para automações críticas

### Access Methods
- **Clone:** Works via SSH
- **Push:** Works via SSH
- **PR/Merge:** Works via gh CLI

### Test Repository
- **Name:** test-vps-github
- **URL:** https://github.com/Smitti7971/test-vps-github
- **Purpose:** Validating GitHub access for automations

---

## SSH

### Local Configuration
- **Hostname:** srv1169527.hstgr.cloud
- **User:** root
- **SSH Key:** ~/.ssh/id_ed25519
- **Public Key:** ~/.ssh/id_ed25519.pub
- **SSH Agent:** Running (PID 1612)
- **GitHub Key Added:** Yes (Smitti7971 account)

### Connection Test
```bash
ssh -T git@github.com
# Returns: Hi Smitti7971! You've successfully authenticated...
```

---

## Installed Skills

### System Skills
- **github** - GitHub CLI interactions (built-in)
- **clawhub** - Skill installation and management

### Installed Skills
- **self-improvement** (v1.0.5)
  - Status: ✅ ACTIVE
  - Purpose: Capture learnings, errors, and corrections
  - Hook: Enabled (agent:bootstrap)
  - Location: /root/.openclaw/workspace/skills/self-improvement-agent

- **n8n** (v1.0.2)
  - Status: ⚠️ Installed (not configured)
  - Purpose: Manage n8n workflows via API
  - Requires: N8N_API_KEY environment variable
  - Location: /root/.openclaw/workspace/skills/n8n

---

## ClawHub

### Configuration
- **CLI:** Installed and functional
- **Registry:** https://clawhub.com (default)
- **Usage:** `clawhub install <skill-name>`

### Example Commands
```bash
# Search skills
clawhub search "keyword"

# Install skill
clawhub install skill-name

# List installed skills
clawhub list

# Update skill
clawhub update skill-name
```

---

## Important Commands

### GitHub Operations
```bash
# Clone via SSH
git clone git@github.com:Smitti7971/repo.git

# Push via SSH
git push origin branch-name

# Create PR via gh CLI
gh pr create --title "Title" --body "Description"

# Merge PR
gh pr merge <pr-number> --merge
```

### Git Configuration
```bash
# Identity
git config --global user.name "MIDIALIZANDO VPS"
git config --global user.email "vps@smitti.dev"
```

### OpenClaw Hooks
```bash
# List hooks
openclaw hooks list

# Enable hook
openclaw hooks enable hook-name

# Disable hook
openclaw hooks disable hook-name
```

---

## Validated Processes

### GitHub Bootstrap for VPS
**Status:** ✅ VALIDATED (7 steps documented in AGENTS.md)

1. Generate SSH key (ed25519)
2. Configure SSH agent
3. Add key to GitHub
4. Install gh CLI
5. Authenticate gh CLI with PAT
6. Configure Git identity
7. Test complete access (clone, push, PR, merge)

### Self-Improvement Skill
**Status:** ✅ VALIDATED (100% functional)

- Hooks working correctly
- Learnings being captured
- Promotion to workspace functional
- Scripts tested and working

### n8n Multi-Cliente
**Status:** ✅ VALIDATED (Production)

- Directory: /opt/n8n-clientes/
- Docker & Docker Compose installed and running
- Scripts functional for client management
- Documentation complete (README.md)
- First client (smitti) running successfully

**Installed Clients:**
- smitti (n8n pessoal) - Porta 5678, Active

**Management Scripts:**
- create-cliente.sh - Create new isolated client
- start-cliente.sh - Start specific client
- stop-cliente.sh - Stop specific client
- restart-cliente.sh - Restart specific client
- list-clientes.sh - List all clients
- backup-all.sh - Backup all volumes

---

## Environment Variables

### GitHub
- **GH_TOKEN:** Configured via gh CLI (not exposed)
- **GIT_AUTHOR_NAME:** MIDIALIZANDO VPS
- **GIT_AUTHOR_EMAIL:** vps@smitti.dev

### n8n (Future)
- **N8N_API_KEY:** Not yet configured
- **N8N_BASE_URL:** Not yet configured

---

## Important Notes

- ✅ **Always test with repository before production operations**
- ✅ **Use self-improvement skill to capture learnings**
- ✅ **Promote critical learnings to AGENTS.md/TOOLS.md**
- ✅ **SSH key located at ~/.ssh/id_ed25519**
- ✅ **GitHub PAT configured in gh CLI**
- ⚠️ **n8n skill installed but requires API key to function**
