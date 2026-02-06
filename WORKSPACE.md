# WORKSPACE.md - Sistema Automático de Captura

Este documento descreve o sistema automatizado de captura de informações na VPS.

## Scripts Automáticos

### 1. auto-learn.sh - Captura de Learnings

**Caminho:** `/root/.openclaw/workspace/scripts/auto-learn.sh`

**Função:** Captura automaticamente learnings, erros e feature requests

**Uso:**
```bash
./auto-learn.sh <tipo> <título> <descrição>

Tipos:
- learning | LRN  - Novo learning descoberto
- error     | ERR  - Erro encontrado
- feature   | FEAT - Sugestão de feature
```

**Exemplos:**
```bash
./auto-learn.sh learning "Nova técnica descoberta" "Use X para fazer Y"
./auto-learn.sh error "Script falhou" "O script X falhou com erro Y"
./auto-learn.sh feature "Adicionar feature Z" "Implementar funcionalidade Z"
```

**Saída:**
- ✅ Learning registrado em `.learnings/LEARNINGS.md`
- ❌ Erro registrado em `.learnings/ERRORS.md`
- 💡 Feature request registrada em `.learnings/FEATURE_REQUESTS.md`

### 2. capture-action.sh - Captura de Ações

**Caminho:** `/root/.openclaw/workspace/scripts/capture-action.sh`

**Função:** Captura automaticamente ações importantes executadas

**Uso:**
```bash
./capture-action.sh <categoria> <descrição>
```

**Exemplos:**
```bash
./capture-action.sh "SISTEMA" "Nginx reiniciado"
./capture-action.sh "DEPLOY" "Novo cliente n8n criado"
./capture-action.sh "BACKUP" "Backup de volumes realizado"
```

**Saída:**
- ✅ Ação registrada em `memory/actions.md`

## Estrutura de Arquivos

### .learnings/
- `LEARNINGS.md` - Learnings descobertos (LRN-YYYYMMDD-XXX)
- `ERRORS.md` - Erros encontrados (ERR-YYYYMMDD-XXX)
- `FEATURE_REQUESTS.md` - Sugestões de features (FEAT-YYYYMMDD-XXX)

### memory/
- `YYYY-MM-DD.md` - Mensagens completas de cada sessão
- `actions.md` - Log de ações importantes

### scripts/
- `auto-learn.sh` - Script de captura automática de learnings
- `capture-action.sh` - Script de captura automática de ações

## Quando Usar

### auto-learn.sh
- ✅ Quando descobrir uma nova técnica melhor
- ✅ Quando resolver um problema difícil
- ✅ Quando encontrar um erro que precisa ser documentado
- ✅ Quando tiver uma ideia de feature

### capture-action.sh
- ✅ Quando executar uma ação importante
- ✅ Quando fazer deploy de algo
- ✅ Quando configurar novo serviço
- ✅ Quando fazer backup

## IDs Automáticos

O sistema gera IDs automaticamente:
- LRN-YYYYMMDD-XXX (Learning)
- ERR-YYYYMMDD-XXX (Erro)
- FEAT-YYYYMMDD-XXX (Feature)
- XXX é um contador de 3 dígitos

Exemplo: LRN-20260206-001

## Integração

Scripts podem ser chamados de forma programática:

```bash
# Após configurar algo
./capture-action.sh "DEPLOY" "Nginx configurado para subdomínios"

# Após resolver um problema
./auto-learn.sh learning "Correção do problema X" "Solução: fazer Y"

# Após encontrar erro
./auto-learn.sh error "Erro no serviço Z" "Erro: mensagem completa"
```

## Status

**Última atualização:** 2026-02-06
**Sistema:** ✅ Ativo e funcionando
**Testes:** ✅ Todos os scripts validados
