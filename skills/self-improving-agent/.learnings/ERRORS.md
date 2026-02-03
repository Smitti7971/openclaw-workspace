# Errors Log

Command failures, exceptions, and unexpected behaviors.

---

## [ERR-20260203-001] gh_auth_token_env_var

**Logged**: 2026-02-03T17:05:00Z
**Priority**: medium
**Status**: resolved
**Area**: infra

### Summary
Exportar GH_TOKEN para variável de ambiente não é persistente para gh CLI

### Error
```
gh repo create Smitti7971/test-vps-github --public --source=. --remote=origin --push
To get started with GitHub CLI, please run: gh auth login
Alternatively, populate the GH_TOKEN environment variable with a GitHub API authentication token.
```

### Context
- Tentativa de criar repositório usando gh CLI
- Token exportado via `export GH_TOKEN=ghp_...`
- gh CLI não reconhecia o token

### Suggested Fix
Usar `echo TOKEN | gh auth login --with-token` para autenticação persistente ao invés de apenas exportar variável de ambiente

### Metadata
- Reproducible: yes
- Related Files: /root/.config/gh/hosts.yml
- See Also: LRN-20260203-001

---
