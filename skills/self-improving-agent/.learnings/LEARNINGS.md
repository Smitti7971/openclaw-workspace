# Learnings Log

Captured learnings, corrections, and discoveries. Review before major tasks.

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
