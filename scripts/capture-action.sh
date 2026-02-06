#!/bin/bash

# Capture-Action Script - Captura automática de ações importantes
# Uso: ./capture-action.sh <categoria> <descrição>

ACTION_LOG="/root/.openclaw/workspace/memory/actions.md"
DATE=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
CATEGORY="$1"
DESCRIPTION="$2"

# Criar diretório e arquivo
mkdir -p "$(dirname "$ACTION_LOG")"
[ ! -f "$ACTION_LOG" ] && cat > "$ACTION_LOG" << 'EOL'
# Actions Log

Log de ações importantes executadas na VPS.

EOL

# Adicionar ação
cat >> "$ACTION_LOG" << EOL

### $DATE - [$CATEGORY]
**Descrição:** $DESCRIPTION

EOL

echo "✅ Ação capturada: $CATEGORY - $DESCRIPTION"
