# Snapshot Metadata Template

Use este template para documentar o estado do sistema ao criar um snapshot.

---

## Informações Básicas

**ID do Snapshot:** `snap-YYYY-MM-DD-description`  
**Data de Criação:** YYYY-MM-DD HH:MM:SS UTC  
**Descrição Breve:** Uma frase descrevendo o propósito deste snapshot

---

## Configurações

### GitHub
- ✅ / ❌ SSH configurado
- ✅ / ❌ gh CLI instalado
- ✅ / ❌ gh CLI autenticado
- ✅ / ❌ Git identity configurado
- ✅ / ❌ Repositório de teste criado
- ✅ / ❌ Operações de push/merge validadas

### Skills
- Listar skills instaladas no workspace
- Listar skills instaladas no sistema (/usr/lib/node_modules/openclaw/skills/)
- Indicar status de cada skill (configurada/não configurada)

### Hooks
- Listar hooks habilitados
- Listar hooks disponíveis

### OpenClaw
- Versão do OpenClaw
- Gateway status
- Modelos disponíveis
- Canais configurados

---

## Serviços

### Serviços Ativos
- SSH agent: [status]
- OpenClaw Gateway: [status]
- Outros serviços: [lista]

### Serviços Configurados
- Cronjobs: [lista]
- Systemd services: [lista]
- Scripts de inicialização: [lista]

---

## Dependências

### Sistema
- OS: [versão]
- Kernel: [versão]
- Pacotes instalados: [lista importante]

### Runtime
- Node.js: [versão]
- npm: [versão]

### CLI Tools
- Git: [versão]
- gh CLI: [versão]
- clawhub CLI: [versão]
- Outras ferramentas: [lista]

---

## Estrutura de Arquivos

### Arquivos Modificados Desde Último Snapshot
- Listar arquivos alterados
- Indicar tipo de alteração

### Novos Arquivos
- Listar novos arquivos criados
- Indicar propósito de cada

### Arquivos Excluídos
- Listar arquivos removidos
- Indicar motivo (se aplicável)

---

## Estado do Workspace

### Documentação Atualizada
- AGENTS.md: [última atualização]
- SOUL.md: [última atualização]
- USER.md: [última atualização]
- TOOLS.md: [última atualização]
- MEMORY.md: [última atualização]

### Memória
- memory/YYYY-MM-DD.md: [último arquivo]
- Entradas importantes: [lista]

### Learnings
- LEARNINGS.md: [último learning]
- ERRORS.md: [último erro]
- FEATURE_REQUESTS.md: [última feature]

---

## Funcionalidades Testadas

### Testes Validados
- [ ] GitHub SSH connection
- [ ] GitHub HTTPS auth
- [ ] git clone
- [ ] git commit
- [ ] git push
- [ ] git pull
- [ ] gh CLI commands
- [ ] clawhub install
- [ ] Skills functionality
- [ ] Hooks functionality

### Testes Pendentes
- Listar testes ainda não realizados
- Indicar importância/urgência

---

## Problemas Conhecidos

### Issues Ativas
- Listar problemas conhecidos
- Indicar severidade
- Indicar workaround (se existir)

### Limitações
- Listar limitações conhecidas
- Indicar impacto (se aplicável)

---

## Notas Adicionais

### Contexto do Snapshot
- Qual foi o objetivo principal?
- Quais objetivos foram alcançados?
- O que ainda está em progresso?

### Decisões Importantes
- Listar decisões tomadas desde o último snapshot
- Indicar razão para cada decisão

### Próximos Passos
- Listar próximos passos planejados
- Indicar prioridade de cada

---

## Assinatura do Snapshot

**Criado por:** MIDIALIZANDO (VPS srv1169527)  
**Repositório:** Smitti7971/openclaw-workspace  
**Método de Criação:** Manual (script ou git commands)  
**Snapshot Validado:** [ ] Sim / [ ] Não

---

**Última atualização deste template:** 2026-02-03 17:42 UTC
