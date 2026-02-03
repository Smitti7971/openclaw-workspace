# 📸 Snapshot Quick Reference

Guia rápido para usar o sistema de snapshots do OpenClaw.

---

## 🚀 Comandos Principais

### Criar Snapshot
```bash
cd /root/.openclaw/workspace
./snapshots-create.sh
```

### Listar Snapshots
```bash
cd /root/.openclaw/workspace
./snapshots-list.sh
```

### Ver Detalhes de um Snapshot
```bash
cd /root/.openclaw/workspace
./snapshots-list.sh snap-2026-02-03-initial
```

### Restaurar Snapshot
```bash
cd /root/.openclaw/workspace
./snapshots-restore.sh snap-2026-02-03-initial
```

---

## 📋 Fluxo de Uso Típico

### Criar Snapshot Antes de Mudanças Importantes
```bash
# 1. Salvar trabalho
git stash  # ou commit

# 2. Criar snapshot
cd /root/.openclaw/workspace
./snapshots-create.sh

# 3. Continuar trabalho
# (pode experimentar sem medo agora)
```

### Restaurar Snapshot se Algo Der Errado
```bash
# 1. (Opcional) Criar snapshot do estado atual
cd /root/.openclaw/workspace
./snapshots-create.sh

# 2. Restaurar snapshot desejado
./snapshots-restore.sh snap-2026-02-03-initial

# 3. Reconfigurar se necessário
# (reinstalar skills, habilitar hooks, etc.)
```

---

## 📝 Convenção de Nomes

Formato: `snap-YYYY-MM-DD-description`

Exemplos:
- `snap-2026-02-03-initial` - Configuração inicial
- `snap-2026-02-03-github-ready` - GitHub configurado
- `snap-2026-02-03-before-experiment` - Antes de experimento
- `snap-2026-02-03-after-experiment` - Após experimento

---

## ⚠️ Avisos Importantes

### Antes de Restaurar
⚠️ **AVISO:** Restaurar APAGA todas as alterações desde o snapshot!

1. Salvar trabalho em progresso
2. Criar snapshot do estado atual (recomendado)
3. Verificar que é o snapshot correto
4. Entender que branch locais e commits serão perdidos

### Durante Criação
⚠️ **AVISO:** Certifique-se que nada importante está em andamento!

1. Salvar todo trabalho
2. Fechar processos importantes
3. Verificar que tudo está commitado

---

## 🎯 Quando Usar

✅ **Crie snapshot quando:**
- Concluir configuração importante
- Antes de experimento arriscado
- Após projeto funcional
- Mudança significativa na infraestrutura
- Milestone completado

❌ **Não crie snapshot automaticamente:**
- Scripts não automatizam criação
- Você deve decidir quando criar
- Use seu julgamento

---

## 📚 Documentação Completa

Para detalhes completos, veja [SNAPSHOT.md](SNAPSHOT.md).

---

## 🔗 Comandos Relacionados

```bash
# Ver git status
git status

# Ver commits recentes
git log --oneline -10

# Ver tags
git tag -l "snap-*"

# Ver diferença entre snapshots
git log --oneline snap-2026-02-03-initial..HEAD

# Criar branch de teste
git checkout -b test-experiment

# Voltar para main
git checkout main
```

---

**Versão:** 1.0.0  
**Última atualização:** 2026-02-03 17:45 UTC
