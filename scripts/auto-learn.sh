#!/bin/bash

# Auto-Learn Script - Captura automática de learnings
# Uso: ./auto-learn.sh <tipo> <título> <descrição>

LEARNINGS_DIR="/root/.openclaw/workspace/.learnings"
LEARNINGS_FILE="$LEARNINGS_DIR/LEARNINGS.md"
ERRORS_FILE="$LEARNINGS_DIR/ERRORS.md"
FEATURE_REQUESTS_FILE="$LEARNINGS_DIR/FEATURE_REQUESTS.md"

DATE=$(date +%Y%m%d)
TIMESTAMP=$(date -u +"%Y-%m-%d %H:%M:%S UTC")
TYPE="$1"
TITLE="$2"
DESCRIPTION="$3"

# Criar diretório se não existir
mkdir -p "$LEARNINGS_DIR"

# Criar arquivos se não existirem
for file in "$LEARNINGS_FILE" "$ERRORS_FILE" "$FEATURE_REQUESTS_FILE"; do
    [ ! -f "$file" ] && echo "# $(basename "$file")" > "$file"
done

# Gerar ID sequencial
get_next_id() {
    local file="$1"
    local prefix="$2"
    local last_id=$(grep -o "${prefix}${DATE}-[0-9]*" "$file" 2>/dev/null | tail -1 | cut -d'-' -f3)
    local next_id=$((last_id + 1))
    # Se não encontrou, começa do 001
    [ "$last_id" = "" ] && next_id=1
    # Formatar com 3 dígitos
    printf "%03d" "$next_id"
}

# Função para adicionar learning
add_learning() {
    local file="$1"
    local prefix="$2"
    local id=$(get_next_id "$file" "$prefix")
    
    cat >> "$file" << EOL

---

## ${prefix}${DATE}-${id}: $TITLE

**Date:** $TIMESTAMP
**Type:** $TYPE

**Description:**
$DESCRIPTION

**Status:** Auto-captured

EOL
}

# Adicionar baseado no tipo
case "$TYPE" in
    learning|LRN)
        add_learning "$LEARNINGS_FILE" "LRN-"
        echo "✅ Learning registrado: $TITLE (LRN-${DATE}-$(get_next_id "$LEARNINGS_FILE" "LRN-"))"
        ;;
    error|ERR)
        add_learning "$ERRORS_FILE" "ERR-"
        echo "❌ Erro registrado: $TITLE (ERR-${DATE}-$(get_next_id "$ERRORS_FILE" "ERR-"))"
        ;;
    feature|FEAT)
        add_learning "$FEATURE_REQUESTS_FILE" "FEAT-"
        echo "💡 Feature request registrada: $TITLE (FEAT-${DATE}-$(get_next_id "$FEATURE_REQUESTS_FILE" "FEAT-"))"
        ;;
    *)
        echo "⚠️  Tipo desconhecido: $TYPE"
        echo "Uso: $0 <learning|error|feature> <título> <descrição>"
        exit 1
        ;;
esac
