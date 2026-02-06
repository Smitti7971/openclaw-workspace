# Learnings Log

Captured learnings, corrections, and discoveries. Review before major tasks.

---

## [LRN-20260203-002] infrastructure

**Logged**: 2026-02-03T18:50:00Z
**Priority**: high
**Status**: resolved
**Area**: infra

### Summary
Configuração de n8n multi-cliente com Docker Compose para isolamento completo entre clientes

### Details
Implementado servidor multi-cliente n8n onde cada cliente tem:
- PostgreSQL exclusivo (postgres:15)
- Volumes persistentes dedicados
- Rede Docker isolada
- Scripts de gerenciamento automatizados
- Documentação completa

Solução baseada em:
- Docker Compose para orquestração
- Scripts bash para automação
- Templates reutilizáveis
- Backup automatizado de volumes

### What was correct
1. Usar docker-compose por cliente para isolamento completo
2. Não expor PostgreSQL para internet (apenas rede interna)
3. Gerar credenciais únicas automaticamente
4. Atribuir portas automaticamente (5678, 5679, 5680...)
5. Usar restart: unless-stopped para resiliência
6. Criar scripts de gerenciamento (create, start, stop, restart, list, backup)
7. Documentar tudo em README.md completo

### Suggested Action
- Considerar criar skill n8n-client-manager para automação avançada
- Implementar monitoramento de recursos por cliente
- Configurar backup automático via crontab

### Metadata
- Source: configuration
- Related Files: /opt/n8n-clientes/
- Tags: docker, n8n, postgres, isolation, multi-client, automation
- See Also: AGENTS.md, TOOLS.md

---

## [LRN-20260203-001] best_practice

**Logged**: 2026-02-03T17:15:00Z
**Priority**: high
**Status**: resolved
**Area**: infra

### Summary
Validação completa de acesso ao GitHub em VPS requer autenticação SSH e token PAT

### Details
Ao validar acesso ao GitHub da VPS sr1169527.hstgr.cloud para automações críticas:
- Conectividade básica (DNS, portas, latência) funcionava
- Git local funcionava para operações de leitura
- Mas falhava ao tentar push sem autenticação configurada
- Solução: gerar chave SSH ed25519, adicionar ao GitHub, configurar gh CLI com PAT

### What was wrong
Tentando validar push sem primeiro configurar autenticação adequada

### What's correct
Pré-requisitos para VPS controlar infraestrutura via GitHub:
1. Gerar chave SSH (ssh-keygen -t ed25519)
2. Adicionar chave pública ao GitHub settings/keys
3. Configurar SSH agent (eval ssh-agent, ssh-add)
4. Criar PAT com scopes: repo, workflow, admin:org
5. Autenticar gh CLI (echo TOKEN | gh auth login --with-token)
6. Testar com repositório de teste antes de produção

### Suggested Action
- Documentar este processo em AGENTS.md para futuras VPS
- Criar script automatizado para bootstrap de novas VPS

### Metadata
- Source: conversation
- Related Files: /root/.openclaw/workspace/memory/2026-02-03.md
- Tags: github, ssh, authentication, vps, validation, infra
- See Also: SKILL.md (skill: github)

---

## [LRN-20260203-003] configuration

**Logged**: 2026-02-03T19:15:00Z
**Priority**: medium
**Status**: resolved
**Area**: infra

### Summary
Erro de cookies seguros no n8n ao acessar via HTTP em vez de HTTPS

### Details
Ao tentar acessar o n8n via HTTP (http://72.61.63.84:5678), recebi erro:
"Your n8n server is configured to use a secure cookie, however you are either visiting this via an insecure URL, or using Safari."

Causa:
- N8N_PROTOCOL configurado como `http` (inseguro)
- n8n por padrão quer usar cookies seguros (HTTPS only)
- Conflito ao acessar via IP público em HTTP não seguro

### What was wrong
Assumir que HTTP funcionaria sem problema em ambiente de teste
N8N_SECURE_COOKIE não foi configurado inicialmente no .env

### What's correct
Solução implementada: Adicionar `N8N_SECURE_COOKIE=false` ao .env para permitir acesso via HTTP em ambiente de teste

Variável adicionada:
```bash
# Fix para erro de cookies seguros
N8N_SECURE_COOKIE=false
```

Após adicionar variável e reiniciar container n8n:
- ✅ Erro de cookies resolvido
- ✅ Acesso funcionando via HTTP
- ✅ Health check OK: {"status":"ok"}
- ✅ HTTP 200 OK no acesso

### Alternative solutions (future)
1. **Recomendado:** Configurar HTTPS com Nginx + Let's Encrypt
2. **Local access:** Usar localhost se acessando da própria VPS
3. **Production:** Usar certificado SSL e N8N_PROTOCOL=https

### Suggested Action
- Para ambientes de teste: Adicionar N8N_SECURE_COOKIE=false ao .env
- Para produção: Configurar Nginx com HTTPS
- Documentar decisão em README.md

### Metadata
- Source: troubleshooting
- Related Files: /opt/n8n-clientes/smitti/.env
- Related Errors: ERR-20260203-002 (execution without permission)
- Tags: n8n, security, cookies, http, https, configuration

---
