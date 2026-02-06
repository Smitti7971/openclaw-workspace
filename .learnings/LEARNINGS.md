# LEARNINGS.md

This file captures important learnings discovered during operation.

---

## LRN-20260206-001: Daily Complete Message Log System

**Date:** 2026-02-06
**Category:** memory_system
**Status:** implemented

**What Happened:**
Smitti requested an improved memory system that saves ALL messages sent, independent of sessions, since he is the only user using OpenClaw.

**Previous Approach:**
- Daily memory files (memory/YYYY-MM-DD.md) were used for summaries only
- Not all messages were captured
- Difficult to reconstruct past conversations

**Solution Implemented:**
Created a complete daily message log system with:

1. **Enhanced Format:** Each message now includes:
   - Full timestamp (HH:MM:SS UTC)
   - Unique message ID
   - Sender (User/System)
   - Complete message content
   - System response context

2. **Automatic Updates:** File is updated in real-time as messages arrive

3. **Session-Independent:** Messages persist across session boundaries

4. **Guideline Documentation:** Added to AGENTS.md (memory/YYYY-MM-DD.md section)

5. **No Permission Required:** This is part of the memory system and doesn't require explicit approval

**Files Modified/Created:**
- Created: memory/2026-02-06.md (new format example)
- Updated: AGENTS.md (added "📋 memory/YYYY-MM-DD.md" section)
- Updated: MEMORY.md (added "Daily Message Log System" section)

**Example Format:**
```markdown
### 16:05:00 UTC - [User: Smitti]
**ID:** c4b077cf-7b43-4ea3-bb70-160134e81bee
**Conteúdo:**
Pode fazer o opção 3

**[Resposta do System]**
Confirmou e implementou a opção 3...
```

**Benefits:**
- Complete history of all conversations
- Easy reconstruction of past sessions
- Single-user optimization (no privacy concerns)
- Standardized format for consistency

**When to Use:**
- Single-user environment only (not shared contexts)
- Complete message history required
- Conversation reconstruction needed

**Reference:** AGENTS.md → memory/YYYY-MM-DD.md section

---

## LRN-20260206-002: Chatwoot server.pid Lock Issue

**Date:** 2026-02-06
**Category:** docker_compose
**Status:** resolved

**What Happened:**
Chatwoot container rails was stuck in restart loop with error:
```
A server is already running (pid: 1, file: /app/tmp/pids/server.pid).
Exiting
```

**Cause:**
The `/app/tmp/pids/server.pid` file was not being cleaned up when the container stopped abruptly, causing subsequent startups to think a server was already running.

**Initial Attempts (Failed):**
1. Tried removing file with `docker-compose exec rails rm -f /app/tmp/pids/server.pid` - container was restarting
2. Tried using `docker-compose run --rm rails rm -f /app/tmp/pids/server.pid` - didn't work
3. Multiple restart attempts - file persisted

**Solution Implemented:**
Modified `/opt/chatwoot-clientes/smitti/docker-compose.yml` to automatically remove the stale PID file before starting the server:

```yaml
command: sh -c "rm -f /app/tmp/pids/server.pid && bundle exec rails s -p 3000 -b 0.0.0.0"
```

After modifying, had to:
1. Remove corrupted container: `docker rm -f <container-id>`
2. Recreate: `docker-compose up -d rails`

**n8n Issue (Also Resolved):**
n8n containers had also stopped (Exited 255). Simple restart resolved:
```bash
docker start smitti_n8n smitti_n8n_redis smitti_n8n_postgres
```

**Files Modified:**
- `/opt/chatwoot-clientes/smitti/docker-compose.yml` (added PID cleanup command)

**Prevention:**
The PID cleanup in docker-compose.yml ensures this issue won't recur on future restarts.

**Reference:**
- n8n access: http://72.61.63.84:5678
- Chatwoot access: http://72.61.63.84:3000

---

## LRN-20260206-003: Nginx Reverse Proxy for Subdomains

**Date:** 2026-02-06
**Category:** nginx
**Status:** implemented

**What Was Done:**
Configured Nginx as reverse proxy for Docker services with subdomains:
- n8n.smitti.midializando.cloud → localhost:5678
- chatwoot.smitti.midializando.cloud → localhost:3000

**Steps Taken:**

1. **Install Nginx:**
   ```bash
   apt update && apt install -y nginx
   systemctl start nginx && systemctl enable nginx
   ```

2. **Create Configuration Files:**

   For n8n (`/etc/nginx/sites-available/n8n.smitti.midializando.cloud`):
   ```nginx
   server {
       listen 80;
       listen [::]:80;
       server_name n8n.smitti.midializando.cloud;

       location / {
           proxy_pass http://localhost:5678;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           proxy_set_header X-Forwarded-Host $host;
           proxy_set_header X-Forwarded-Port $server_port;
       }
   }
   ```

   For Chatwoot (`/etc/nginx/sites-available/chatwoot.smitti.midializando.cloud`):
   ```nginx
   server {
       listen 80;
       listen [::]:80;
       server_name chatwoot.smitti.midializando.cloud;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
           proxy_set_header X-Real-IP $remote_addr;
           proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
           proxy_set_header X-Forwarded-Proto $scheme;
           proxy_set_header X-Forwarded-Host $host;
           proxy_set_header X-Forwarded-Port $server_port;
       }
   }
   ```

3. **Enable Sites:**
   ```bash
   ln -s /etc/nginx/sites-available/n8n.smitti.midializando.cloud /etc/nginx/sites-enabled/
   ln -s /etc/nginx/sites-available/chatwoot.smitti.midializando.cloud /etc/nginx/sites-enabled/
   rm -f /etc/nginx/sites-enabled/default
   nginx -t
   systemctl reload nginx
   ```

4. **Test:**
   ```bash
   curl -I http://localhost/ -H "Host: n8n.smitti.midializando.cloud"
   curl -I http://localhost/ -H "Host: chatwoot.smitti.midializando.cloud"
   ```

**Important Notes:**

- DNS records must be created separately:
  - `n8n.smitti.midializando.cloud` → A record → `72.61.63.84`
  - `chatwoot.smitti.midializando.cloud` → A record → `72.61.63.84`

- Proxy headers are critical for proper WebSocket support and IP forwarding
- Remove default site to avoid conflicts
- Test with `nginx -t` before reloading

**Files Created/Modified:**
- `/etc/nginx/sites-available/n8n.smitti.midializando.cloud` (new)
- `/etc/nginx/sites-available/chatwoot.smitti.midializando.cloud` (new)
- Symlinks created in `/etc/nginx/sites-enabled/`

**Benefits:**
- Clean subdomain-based URLs
- WebSocket support via proxy headers
- Can add SSL certificates later (Let's Encrypt)
- Centralized reverse proxy for all services

---

## LRN-20260206-004: Let's Encrypt HTTPS Configuration

**Date:** 2026-02-06
**Category:** ssl
**Status:** implemented

**What Was Done:**
Configured HTTPS with Let's Encrypt for both subdomains using certbot with automatic renewal.

**Steps Taken:**

1. **Install Certbot:**
   ```bash
   apt install -y certbot python3-certbot-nginx
   ```

2. **Generate SSL Certificates:**
   ```bash
   certbot --nginx -d n8n.smitti.midializando.cloud -d chatwoot.smitti.midializando.cloud --email vps@smitti.dev --agree-tos --no-eff-email --redirect
   ```

   **Flags used:**
   - `--nginx`: Automatically configure Nginx
   - `--redirect`: Automatically redirect HTTP to HTTPS
   - `--agree-tos`: Agree to Terms of Service
   - `--no-eff-email`: Don't share email with EFF

3. **Results:**
   - ✅ Certificate generated for both domains
   - ✅ Nginx automatically configured with SSL
   - ✅ HTTP → HTTPS redirect enabled
   - ✅ Timer enabled for automatic renewal (twice daily)

4. **Certificate Details:**
   - Location: `/etc/letsencrypt/live/n8n.smitti.midializando.cloud/`
   - Expires: 2026-05-07
   - Auto-renewal: Enabled via `certbot.timer`

5. **Verification:**
   ```bash
   curl -I https://n8n.smitti.midializando.cloud/
   curl -I https://chatwoot.smitti.midializando.cloud/
   ```

**Nginx Configuration (Modified by Certbot):**

Certbot automatically added SSL configuration to both site files:
```nginx
server {
    # ... existing proxy config ...

    listen [::]:443 ssl ipv6only=on;
    listen 443 ssl;
    ssl_certificate /etc/letsencrypt/live/n8n.smitti.midializando.cloud/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/n8n.smitti.midializando.cloud/privkey.pem;
    include /etc/letsencrypt/options-ssl-nginx.conf;
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem;
}

# HTTP redirect
server {
    if ($host = n8n.smitti.midializando.cloud) {
        return 301 https://$host$request_uri;
    }
    listen 80;
    listen [::]:80;
    server_name n8n.smitti.midializando.cloud;
    return 404;
}
```

**Auto-Renewal:**

Certbot timer runs twice daily and automatically renews certificates 30 days before expiration.

Check status:
```bash
systemctl status certbot.timer
```

**Important Notes:**

- Certificates are shared across both domains (SAN certificate)
- HTTP automatically redirects to HTTPS
- Certificates renew automatically
- No manual intervention needed

**Files Created/Modified:**
- `/etc/letsencrypt/live/n8n.smitti.midializando.cloud/` (certificate files)
- `/etc/letsencrypt/live/n8n.smitti.midializando.cloud/fullchain.pem`
- `/etc/letsencrypt/live/n8n.smitti.midializando.cloud/privkey.pem`
- `/etc/nginx/sites-enabled/n8n.smitti.midializando.cloud` (SSL added)
- `/etc/nginx/sites-enabled/chatwoot.smitti.midializando.cloud` (SSL added)
- `/etc/letsencrypt/options-ssl-nginx.conf` (SSL options)
- `/etc/letsencrypt/ssl-dhparams.pem` (DH params)

**Benefits:**
- Free SSL certificates
- Automatic renewal
- Modern TLS configuration
- HTTP to HTTPS redirect
- Browser security indicators working

**Validation:**
- ✅ User confirmed HTTPS is working (2026-02-06 17:11 UTC)
- ✅ Both subdomains accessible via HTTPS
- ✅ Browser security indicators (green lock) visible
