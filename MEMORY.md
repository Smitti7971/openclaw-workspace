# MEMORY.md - Long-Term Memory

> This file is your curated memory — the distilled essence of important information that persists across sessions.

> ⚠️ **IMPORTANT:** This file is ONLY loaded in main session (direct chats with Smitti). DO NOT load in shared contexts (Discord, group chats, sessions with other people).

---

## VPS Information

### Server Details
- **Hostname:** srv1169527
- **User:** root
- **Type:** Production VPS
- **Configuration Date:** 2026-02-03
- **Operating System:** Linux 6.8.0-90-generic (x64)
- **Node:** v22.22.0
- **Default Model:** zai/glm-4.7

### Purpose
This VPS is MIDIALIZANDO's administrative server for managing infrastructure and automations via GitHub.

---

## GitHub Automation Status

### Overall Status
✅ **APTO PARA AUTOMAÇÕES CRÍTICAS BASEADAS EM GITHUB**

### Authentication
- **Method:** SSH + Personal Access Token (PAT)
- **Account:** Smitti7971
- **SSH Key:** ed25519, configured at ~/.ssh/id_ed25519
- **gh CLI:** v2.45.0, authenticated with PAT
- **SSH Agent:** Running and functional

### Validated Operations
✅ Clone repositories (read access)
✅ Push to repositories (write access)
✅ Create Pull Requests via gh CLI
✅ Merge Pull Requests via API
✅ Create branches
✅ Switch between branches
✅ Git operations: pull, status, commit
✅ Repository management via gh CLI

### Test Repository
- **Name:** test-vps-github
- **Owner:** Smitti7971
- **URL:** https://github.com/Smitti7971/test-vps-github
- **Purpose:** Validation and testing of GitHub access
- **Status:** All tests passed (push, PR, merge working)

---

## Installed Skills

### self-improvement (v1.0.5)
**Status:** ✅ ACTIVE AND FULLY FUNCTIONAL

**Purpose:** Capture learnings, errors, and corrections for continuous improvement

**What It Does:**
- Logs learnings to `.learnings/LEARNINGS.md`
- Logs errors to `.learnings/ERRORS.md`
- Logs feature requests to `.learnings/FEATURE_REQUESTS.md`
- Promotes important learnings to workspace files (AGENTS.md, TOOLS.md, SOUL.md)
- Hooks: Enabled (agent:bootstrap event)

**When to Use:**
1. User corrects the agent
2. Command/operation fails unexpectedly
3. User requests capability that doesn't exist
4. External API or tool fails
5. Agent realizes knowledge is outdated or incorrect
6. Better approach discovered for recurring task

**Validated:**
- ✅ All 16 tests passed (100% success rate)
- ✅ Hooks working correctly
- ✅ Learnings being captured
- ✅ Promotion to workspace functional
- ✅ Scripts tested and working

**Location:** /root/.openclaw/workspace/skills/self-improving-agent/

---

### n8n (v1.0.2)
**Status:** ⚠️ INSTALLED (NOT YET CONFIGURED - API SKILL)

**Purpose:** Manage n8n workflows and automations via API

**Requirements:**
- N8N_API_KEY environment variable
- N8N_BASE_URL (optional, default available)

**What It Can Do:**
- List workflows (active/inactive)
- Get workflow details
- Activate/deactivate workflows
- List executions
- Get execution details
- Manually trigger workflows
- Debug workflow issues

**Location:** /root/.openclaw/workspace/skills/n8n/

**Next Steps:** Configure N8N_API_KEY to enable functionality

---

## Nginx Reverse Proxy

**Status:** ✅ INSTALLED AND CONFIGURED (2026-02-06)

**Configuration Directory:** /etc/nginx/
**Version:** 1.24.0 (Ubuntu)

**Purpose:** Provide reverse proxy for Docker services via subdomains

**Configured Subdomains:**
- n8n.smitti.midializando.cloud → http://localhost:5678
- chatwoot.smitti.midializando.cloud → http://localhost:3000

**Configuration Files:**
- `/etc/nginx/sites-available/n8n.smitti.midializando.cloud`
- `/etc/nginx/sites-available/chatwoot.smitti.midializando.cloud`

**Enabled Sites:**
- `/etc/nginx/sites-enabled/n8n.smitti.midializando.cloud` (symlink)
- `/etc/nginx/sites-enabled/chatwoot.smitti.midializando.cloud` (symlink)

**Status:**
- Service: ✅ Active and running
- Configuration: ✅ Syntax valid
- Proxy: ✅ HTTP 200 for both subdomains
- HTTPS: ✅ Let's Encrypt configured and working
- Auto-renewal: ✅ Twice daily (certbot.timer)

**Acessos:**
- **n8n:** https://n8n.smitti.midializando.cloud ✅
- **Chatwoot:** https://chatwoot.smitti.midializando.cloud ✅
- HTTP redireciona automaticamente para HTTPS

**Certificates:**
- Issued: 2026-02-06
- Expires: 2026-05-07
- Auto-renewal: ✅ certbot.timer (twice daily)

**Service Management:**
```bash
# Check status
systemctl status nginx

# Reload configuration
systemctl reload nginx

# Test configuration
nginx -t

# View error logs
tail -f /var/log/nginx/error.log

# View access logs
tail -f /var/log/nginx/access.log
```

**Reference:** LRN-20260206-003 in .learnings/LEARNINGS.md

---

## n8n Multi-Cliente (Docker Compose)
**Status:** ✅ INSTALLED AND VALIDATED (Production)

**Purpose:** Run multiple isolated n8n instances, each with exclusive PostgreSQL database using Docker Compose

**Configuration Date:** 2026-02-03
**Directory:** /opt/n8n-clientes/

**Key Features:**
- ✅ Isolated PostgreSQL per client
- ✅ Exclusive persistent volumes
- ✅ Independent Docker networks
- ✅ Automatic client creation scripts
- ✅ Management scripts (start/stop/restart/list)
- ✅ Backup automation
- ✅ Complete documentation (README.md)

**Currently Installed Clients:**
- smitti (n8n pessoal) - Porta 5678 - Status: Active

**Client Access (smitti):**
- URL: http://72.61.63.84:5678
- Basic Auth User: smitti_admin
- Database: smitti_db
- Database User: smitti_user
- Full credentials saved in: /opt/n8n-clientes/smitti/INFO.txt

**Management Scripts:**
- `/opt/n8n-clientes/scripts/create-cliente.sh` - Create new isolated client
- `/opt/n8n-clientes/scripts/start-cliente.sh` - Start specific client
- `/opt/n8n-clientes/scripts/stop-cliente.sh` - Stop specific client
- `/opt/n8n-clientes/scripts/restart-cliente.sh` - Restart specific client
- `/opt/n8n-clientes/scripts/list-clientes.sh` - List all clients
- `/opt/n8n-clientes/scripts/backup-all.sh` - Backup all volumes

**Documentation:** `/opt/n8n-clientes/README.md`

**Architecture:**
- Each client has own docker-compose.yml
- Each client has own .env with credentials
- Each client uses PostgreSQL 15
- Each client uses n8nio/n8n:latest
- PostgreSQL not exposed to internet (internal network only)
- Each n8n instance on unique external port (5678, 5679, 5680...)

**Resources per Client:**
- RAM: ~512MB-1GB
- Disk: ~1-2GB
- Network: Isolated bridge network

---

## Validated Processes

### VPS GitHub Bootstrap Process
**Status:** ✅ VALIDATED AND DOCUMENTED

**Location:** AGENTS.md (VPS GitHub Bootstrap section)

**Steps (7 total):**
1. Generate SSH key (ed25519)
2. Configure SSH agent
3. Add key to GitHub settings/keys
4. Install gh CLI
5. Authenticate gh CLI with PAT
6. Configure Git identity
7. Test complete access (clone, push, PR, merge)

**Validation Checklist:**
- [x] SSH connection works
- [x] gh CLI authenticated
- [x] Git identity configured
- [x] Can clone (read access)
- [x] Can push (write access)
- [x] Can create PR
- [x] Can merge PR

---

### Self-Improvement Workflow
**Status:** ✅ VALIDATED

**Learnings Captured:**
- LRN-20260203-001: Complete GitHub validation process
- ERR-20260203-001: gh CLI authentication issue
- FEAT-20260203-001: vps-bootstrap automation skill

**Promoted to Workspace:**
- LRN-20260203-001 → AGENTS.md (VPS GitHub Bootstrap section)

**Hook Configuration:**
- Hook: self-improvement
- Event: agent:bootstrap
- Status: ✓ ready
- Action: Injects reminder to check .learnings/ before major tasks

---

## Important Guidelines

### GitHub Operations
- **Always test with test repository before production**
- **Use SSH for authentication (preferred)**
- **Use gh CLI for advanced operations (PRs, merges)**
- **Reference:** AGENTS.md → VPS GitHub Bootstrap

### Continuous Improvement
- **Use self-improvement skill to capture learnings**
- **Promote critical learnings to workspace files**
- **Review learnings before major tasks**
- **Reference:** .learnings/ directory

### Documentation
- **Keep TOOLS.md updated with tool-specific configurations**
- **Keep AGENTS.md updated with workflow patterns**
- **Use MEMORY.md for long-term, high-value information**
- **Use memory/YYYY-MM-DD.md for complete daily message logs** (updated 2026-02-06)

### Security
- **Never expose sensitive values (API keys, tokens)**
- **Use environment variables for sensitive data**
- **PAT is stored in gh CLI config (not in plain text)**
- **SSH private key is protected (permissions 600)**

---

## Chatwoot Multi-Cliente (Docker Compose)
**Status:** ✅ INSTALLED AND VALIDATED (Production)

**Configuration Date:** 2026-02-06
**Directory:** /opt/chatwoot-clientes/

**Key Features:**
- ✅ Isolated PostgreSQL per client (pgvector/pgvector:pg15)
- ✅ Redis with password authentication
- ✅ Rails application server
- ✅ Sidekiq background jobs
- ✅ Persistent storage volumes
- ✅ Independent Docker networks

**Currently Installed Clients:**
- smitti (Chatwoot pessoal) - Porta 3000 - Status: Active

**Client Access (smitti):**
- URL: http://72.61.63.84:3000
- Database: smitti_db
- Database User: chatwoot_user
- Full configuration in: /opt/chatwoot-clientes/smitti/docker-compose.yml

**Services Running:**
- smitti-chatwoot-postgres (healthy, port 5432 internal)
- smitti-chatwoot-redis (healthy, port 6379 internal)
- smitti-chatwoot-rails (port 3000 external)
- smitti-chatwoot-sidekiq (background jobs)

**Known Issue (Resolved):**
- **server.pid lock:** Chatwoot rails container gets stuck in restart loop if not stopped cleanly
- **Fix:** Modified docker-compose.yml to clean up PID file on startup
- **Command:** `sh -c "rm -f /app/tmp/pids/server.pid && bundle exec rails s -p 3000 -b 0.0.0.0"`
- **Reference:** LRN-20260206-002 in .learnings/LEARNINGS.md

**Architecture:**
- Each client has own docker-compose.yml
- Each client has own PostgreSQL with pgvector support
- Each client uses chatwoot/chatwoot:latest
- PostgreSQL and Redis not exposed to internet (internal network only)
- Each Chatwoot instance on unique external port (3000, 3001, 3002...)

---

## Key Learnings

### GitHub Authentication (LRN-20260203-001)
**Problem:** Initial attempts to push to GitHub failed because authentication wasn't configured.

**Solution:** Complete authentication setup includes:
1. SSH key generation and GitHub setup
2. gh CLI installation and PAT authentication
3. Git identity configuration
4. Full validation test suite

**Reference:** See AGENTS.md → VPS GitHub Bootstrap

---

### gh CLI Token Authentication (ERR-20260203-001)
**Problem:** Exporting GH_TOKEN to environment variable doesn't work persistently for gh CLI.

**Error:** `gh repo create` returned "To get started with GitHub CLI, please run: gh auth login"

**Solution:** Use `echo TOKEN | gh auth login --with-token` for persistent authentication instead of just `export GH_TOKEN`.

---

## Tasks and Projects

### Pending
- Configure n8n skill (requires N8N_API_KEY)
- Consider implementing vps-bootstrap skill (FEAT-20260203-001)

### Completed
- ✅ VPS GitHub validation (2026-02-03)
- ✅ self-improvement skill installation and testing (2026-02-03)
- ✅ n8n skill installation (2026-02-03)
- ✅ Daily message log system implemented (2026-02-06)
- ✅ n8n and Chatwoot services restored (2026-02-06)

---

## Contact Information

**User:** Smitti
**Pronouns:** dele
**Timezone:** Brasil

---

## Last Updated
**Date:** 2026-02-03
**Session:** Initial configuration and validation

---

## Daily Message Log System (memory/YYYY-MM-DD.md)

**Status:** ✅ ACTIVE (Implemented 2026-02-06)

**Purpose:** Capture ALL messages exchanged in each session, enabling reconstruction of previous conversations independent of session boundaries.

**When to Use:**
- Single-user environment (Smitti only)
- Complete message history required
- Reconstruction of past conversations needed

**Format Structure:**
- Timestamp (UTC)
- Message ID
- Sender (User/System)
- Full message content
- System response context

**Documentation:** See AGENTS.md → memory/YYYY-MM-DD.md section

**Example:** `/root/.openclaw/workspace/memory/2026-02-06.md`

---

## Quick Reference

### GitHub Access Test
```bash
ssh -T git@github.com
# Should return: Hi Smitti7971! You've successfully authenticated...
```

### Test Repository
https://github.com/Smitti7971/test-vps-github

### Skill Locations
- self-improvement: /root/.openclaw/workspace/skills/self-improving-agent/
- n8n: /root/.openclaw/workspace/skills/n8n/

### Learnings Location
- /root/.openclaw/workspace/.learnings/
  - LEARNINGS.md
  - ERRORS.md
  - FEATURE_REQUESTS.md

### OpenClaw Hooks
```bash
openclaw hooks list
openclaw hooks enable <hook-name>
openclaw hooks disable <hook-name>
```
