# Feature Requests

Capabilities requested by user that don't currently exist.

---

## [FEAT-20260203-001] vps_bootstrap_automation

**Logged**: 2026-02-03T17:18:00Z
**Priority**: medium
**Status**: pending
**Area**: infra

### Requested Capability
Script automatizado para bootstrap de novas VPS com acesso completo ao GitHub

### User Context
Ao configurar uma nova VPS para automações críticas baseadas em GitHub, são necessários múltiplos passos manuais:
- Gerar chaves SSH
- Configurar SSH agent
- Instalar e autenticar gh CLI
- Validar todos os acessos
- Testar operações de escrita

Ter um script automatizado reduziria tempo e erros humanos.

### Complexity Estimate
medium

### Suggested Implementation
Criar skill `vps-bootstrap` com scripts que:
1. Gera chave SSH automaticamente
2. Exibe chave pública para usuário adicionar ao GitHub
3. Instala gh CLI
4. Solicita PAT do usuário
5. Configura autenticação
6. Executa bateria completa de testes
7. Gera relatório de status
8. Opcional: adiciona cronjobs para manutenção

### Metadata
- Frequency: recurring (toda nova VPS)
- Related Features: self-improvement, github

---
