# Sistema de Snapshot Manual via GitHub

Mecanismo manual de criação e restauração de snapshots utilizando GitHub para preservar o estado completo do projeto em pontos específicos do tempo.

---

## 📋 Definição

Um **snapshot** é uma representação fiel e completa do estado atual do workspace do OpenClaw no momento da sua criação. Ao restaurar um snapshot, o projeto deve retornar exatamente ao mesmo estado funcional e estrutural existente naquele momento.

---

## 🎯 Objetivo

- Preservar o estado atual do projeto em pontos específicos do tempo
- Permitir restauração manual para qualquer snapshot criado
- Manter histórico completo de alterações
- Permitir rollback para qualquer ponto anterior

---

## 📐 Regras Obrigatórias

### ✅ Criação Manual
- Snapshots devem ser criados SOMENTE de forma manual pelo usuário
- NENHUM processo automático de criação
- Scripts são APENAS ferramentas de conveniência, não automação

### ✅ Restauração Manual
- Restauração de snapshot é feita EXCLUSIVAMENTE pelo usuário
- Sistema NÃO deve restaurar automaticamente
- Sistema NÃO deve sugerir restauração automaticamente

### ✅ Imutabilidade
- Snapshots criados NÃO podem ser alterados posteriormente
- Snapshots antigos devem ser PRESERVADOS para rollback histórico
- Usar GitHub Tags (não modificáveis)

### ✅ Estado Completo
Cada snapshot reflete INTEGRALMENTE o estado atual do projeto:
- Código-fonte (todos os arquivos do workspace)
- Configurações (AGENTS.md, SOUL.md, USER.md, TOOLS.md, etc.)
- Dependências (package.json, skills instaladas)
- Estrutura de diretórios
- Scripts e arquivos auxiliares
- Skills instaladas em workspace/
- Memória (MEMORY.md, memory/)

### ✅ Rastreamento de Estado
Cada snapshot contém descrição EXPLÍCITA do estado do sistema:
- Configurações realizadas
- Serviços configurados
- Dependências instaladas
- Ajustes estruturais relevantes
- Skills instaladas e configuradas
- Estado de hooks habilitados

Esta descrição é registrada de forma versionada (mensagem da tag).

### ✅ Uso do GitHub
- GitHub é repositório de versionamento e armazenamento de snapshots
- Múltiplos snapshots históricos são mantidos (sem sobrescrita)
- Cada snapshot é identificável de forma clara (tag)
- Usuário pode selecionar qualquer snapshot para restauração manual

---

## 🚫 Comportamentos Proibidos

- ❌ Criar apenas um único snapshot sobrescrevendo o anterior
- ❌ Automatizar criação ou recuperação de snapshots
- ❌ Modificar snapshots já existentes
- ❌ Excluir snapshots antigos sem ação explícita do usuário
- ❌ Usar branches como snapshots (tags são imutáveis)

---

## 🔧 Como Funciona

### Base Técnica: GitHub Tags

Snapshots são implementados usando **GitHub Tags**:
- Tags são imutáveis (não podem ser alteradas)
- Cada tag é um ponto fixo no histórico
- Múltiplas tags podem coexistir
- Identificação clara via nome da tag

### Estrutura

```
GitHub Repository (Smitti7971/openclaw-workspace)
├── main branch (estado atual/último snapshot)
├── snap-2026-02-03-initial (tag)
├── snap-2026-02-03-github-configured (tag)
├── snap-2026-02-03-skills-installed (tag)
└── snap-YYYY-MM-DD-description (tag)
```

---

## 📝 Como Criar um Snapshot

### Método 1: Script Auxiliar (Recomendado)

```bash
# Acessar workspace
cd /root/.openclaw/workspace

# Executar script de criação
./snapshots-create.sh "Descrição do snapshot"
```

O script:
1. Pede confirmação
2. Adiciona todos os arquivos ao git
3. Commit com descrição detalhada
4. Push para GitHub
5. Cria tag imutável
6. Push da tag para GitHub
7. Registra metadata em .snapshots/

### Método 2: Manual via Git

```bash
# 1. Acessar workspace
cd /root/.openclaw/workspace

# 2. Adicionar todos os arquivos
git add .

# 3. Commit com descrição detalhada
git commit -m "snapshot: Descrição detalhada do estado

[Snapshot Details]
Date: 2026-02-03 17:40:00 UTC
Description: Descrição do snapshot
Configurations: List configurations made
Services: List services configured
Dependencies: List dependencies installed
Skills: List skills installed and configured
Hooks: List hooks enabled
Changes: Brief description of what changed since last snapshot"

# 4. Push para GitHub
git push origin main

# 5. Criar tag imutável
SNAPSHOT_DATE=$(date +%Y-%m-%d-%H%M)
git tag -a "snap-${SNAPSHOT_DATE}-description" -m "Snapshot: Descrição do snapshot"

# 6. Push da tag para GitHub
git push origin "snap-${SNAPSHOT_DATE}-description"
```

---

## 📋 Como Listar Snapshots

### Método 1: Script Auxiliar

```bash
cd /root/.openclaw/workspace
./snapshots-list.sh
```

### Método 2: Via Git

```bash
# Listar tags de snapshot
git tag -l "snap-*"

# Listar com datas
git tag -l "snap-*" --sort=-creatordate

# Ver detalhes de um snapshot
git show snap-2026-02-03-initial --stat
```

---

## 🔄 Como Restaurar um Snapshot

### Método 1: Script Auxiliar (Recomendado)

```bash
# Acessar workspace
cd /root/.openclaw/workspace

# Executar script de restauração
./snapshots-restore.sh "snap-2026-02-03-initial"
```

O script:
1. Mostra detalhes do snapshot
2. Pede confirmação do usuário
3. Reset workspace para o estado do snapshot
4. Apaga branches locais não desejados
5. Reinstala skills se necessário
6. Reaplica configurações se necessário
7. Reporta estado final

### Método 2: Manual via Git

```bash
# 1. Acessar workspace
cd /root/.openclaw/workspace

# 2. Buscar tags mais recentes
git fetch --tags

# 3. Ver detalhes do snapshot
git show snap-2026-02-03-initial --stat

# 4. Reset workspace para o snapshot
git reset --hard snap-2026-02-03-initial

# 5. Sincronizar remote
git push origin main --force

# 6. Reinstalar skills se necessário
clawhub list
# Reinstalar skills que estavam no snapshot

# 7. Reconfigurar hooks se necessário
openclaw hooks list
# Reabilitar hooks que estavam ativos
```

⚠️ **IMPORTANTE:** Resetar com `--force` apaga alterações não salvas no main!

---

## 📌 Convenção de Nomes de Snapshots

Formato: `snap-YYYY-MM-DD-description`

Exemplos:
- `snap-2026-02-03-initial` - Configuração inicial
- `snap-2026-02-03-github-ready` - GitHub configurado
- `snap-2026-02-03-skills-installed` - Skills instaladas
- `snap-2026-02-03-before-experiment` - Antes de experimento
- `snap-2026-02-03-after-experiment` - Após experimento
- `snap-2026-02-03-production-ready` - Sistema pronto para produção

**Regras:**
- Data no formato YYYY-MM-DD
- Descrição em kebab-case (palavras separadas por hífens)
- Descrição deve ser descritiva e curta
- Evitar caracteres especiais

---

## 📊 O que é Incluído no Snapshot

### Arquivos do Workspace

✅ **Sempre incluídos:**
- `AGENTS.md` - Configurações do agente
- `SOUL.md` - Personalidade e comportamento
- `USER.md` - Informações do usuário
- `TOOLS.md` - Notas de ferramentas
- `MEMORY.md` - Memória de longo prazo (main session only)
- `memory/` - Memória diária
- `skills/` - Skills instaladas no workspace
- `.snapshots/` - Metadata de snapshots
- `.openclaw/` - Configurações do OpenClaw
- Arquivos de configuração (.gitconfig, etc.)

❌ **Excluídos via .gitignore:**
- Tokens e chaves privadas (se não versionadas)
- Arquivos temporários
- Cache e logs

---

## 🔍 Rastreamento de Estado

### Template de Descrição de Snapshot

Ao criar um snapshot, incluir esta informação na mensagem do commit/tag:

```
[Snapshot Details]
Date: 2026-02-03 17:40:00 UTC
Description: Breve descrição do propósito deste snapshot

[Configurations]
- GitHub: SSH configured, PAT set, gh CLI authenticated
- Skills: self-improvement, github, n8n (installed but not configured)
- Hooks: self-improvement enabled
- Git Identity: MIDIALIZANDO VPS <vps@smitti.dev>

[Services]
- SSH agent: Running
- OpenClaw Gateway: Active

[Dependencies]
- Node: v22.22.0
- Git: v2.43.0
- gh CLI: v2.45.0
- clawhub CLI: v0.5.0

[Skills Installed]
- /usr/lib/node_modules/openclaw/skills/github (built-in)
- /root/.openclaw/workspace/skills/self-improvement-agent v1.0.5
- /root/.openclaw/workspace/skills/n8n v1.0.2

[Hooks Enabled]
- 🚀 boot-md
- 📝 command-logger
- 💾 session-memory
- 🧠 self-improvement

[Files Modified]
- AGENTS.md (added VPS GitHub Bootstrap section)
- .learnings/LEARNINGS.md (added LRN-20260203-001)
- .learnings/ERRORS.md (added ERR-20260203-001)
- .learnings/FEATURE_REQUESTS.md (added FEAT-20260203-001)

[Notes]
- GitHub access fully validated
- VPS ready for critical GitHub-based automations
- n8n skill installed but not configured (needs API key)
```

---

## 🎓 Melhores Práticas

### Quando Criar Snapshots

✅ **Crie snapshot quando:**
- Concluir configuração importante
- Antes de experimento arriscado
- Após projeto funcional
- Mudança significativa na infraestrutura
- Preparar para produção
- Após instalação de novas skills
- Antes de refatoração major
- Milestone completado

### Como Descrever Snapshots

✅ **Boas descrições:**
- `initial` - Primeira configuração
- `github-ready` - GitHub totalmente configurado
- `production-ready` - Sistema pronto para produção
- `before-experiment-x` - Antes do experimento X
- `after-experiment-x` - Após o experimento X

❌ **Descrições ruins:**
- `snapshot-1` - Não descritivo
- `test` - Vago
- `backup` - Não indica estado
- `temp` - Parece descartável

### Manutenção de Snapshots

✅ **Mantenha:**
- Snapshots importantes/milestones
- Snapshots antes de mudanças arriscadas
- Último snapshot funcional após cada dia de trabalho

❌ **Não exclua automaticamente:**
- Snapshots antigos
- Snapshots que parecem "inúteis"
- Snapshots com falhas (podem ser úteis para diagnóstico)

---

## ⚠️ Avisos Importantes

### Antes de Restaurar

⚠️ **AVISO:** Restaurar um snapshot APAGA todas as alterações feitas desde o snapshot!

1. **Backup de alterações não salvas:**
   - Salvar trabalho em progresso
   - Documentar mudanças não commitadas
   - Criar branch temporário se necessário

2. **Verificar snapshot:**
   - Ler descrição do snapshot
   - Verificar data e estado
   - Confirmar que é o snapshot correto

3. **Entender implicações:**
   - Branches locais podem ser perdidos
   - Commits não pushados serão perdidos
   - Skills instaladas podem precisar de reinstalação

### Durante Criação

⚠️ **AVISO:** Certifique-se que nada importante está em andamento!

1. Salvar todo trabalho
2. Fechar processos importantes
3. Verificar que tudo está commitado
4. Revisar arquivos que serão incluídos
5. Confirmar descrição do snapshot

---

## 📂 Diretório .snapshots/

Metadados dos snapshots são armazenados em `.snapshots/`:

```
.snapshots/
├── INDEX.md              # Índice de todos os snapshots
├── snap-2026-02-03-initial/
│   ├── metadata.md       # Metadata do snapshot
│   └── checklist.md     # Checklist do estado
└── TEMPLATE.md          # Template de metadata
```

---

## 🔗 Recursos Relacionados

- [AGENTS.md](AGENTS.md) - Configurações do agente
- [SKILL.md](skills/self-improvement-agent/SKILL.md) - Skill self-improvement
- [GitHub](https://github.com/Smitti7971/openclaw-workspace) - Repositório no GitHub

---

## 📞 Suporte

Se encontrar problemas:
1. Verificar se GitHub está acessível
2. Verificar credenciais SSH
3. Verificar se workspace está no estado correto
4. Consultar logs do script se usado
5. Consultar documentação do Git para comandos básicos

---

**Última atualização:** 2026-02-03 17:40 UTC
**Versão:** 1.0.0
**Status:** Operacional
