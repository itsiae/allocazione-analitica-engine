#!/bin/bash

# Nome del tag da usare
TAG_NAME=$1

# Lista dei tag permessi
ALLOWED_TAGS=("PLAN-COLLAUDO" "PLAN-CERTIFICAZIONE" "COLLAUDO" "CERTIFICAZIONE")

# Funzione per controllare se il tag è valido
function is_valid_tag() {
  local tag="$1"
  for allowed in "${ALLOWED_TAGS[@]}"; do
    if [[ "$tag" == "$allowed" ]]; then
      return 0
    fi
  done
  return 1
}

if [[ "$1" == "--help" || "$1" == "-h" ]]; then
  echo "Utilizzo: ./deploy-tag.sh <tag>"
  echo "Tag disponibili e corrispondenza pipeline:"
  echo "  PLAN-COLLAUDO       🟢 → pipeline di plan in ambiente di DEV AWS"
  echo "  PLAN-CERTIFICAZIONE 🟡 → pipeline di plan in ambiente di QA AWS"
  echo "  COLLAUDO            🟢 → pipeline di deploy in ambiente di DEV AWS"
  echo "  CERTIFICAZIONE      🟡 → pipeline di deploy in ambiente di QA AWS"
  echo "Esempio: ./deploy-tag.sh PLAN-COLLAUDO"
  exit 0
fi

if [ -z "$TAG_NAME" ]; then
  echo "❌ Devi specificare il nome del tag. Uso: ./deploy_tag.sh <tag>"
  echo "Tag possibili: ${ALLOWED_TAGS[*]}"
  exit 1
fi

if ! is_valid_tag "$TAG_NAME"; then
  echo "❌ Tag non valido: '$TAG_NAME'"
  echo "I tag possibili sono: ${ALLOWED_TAGS[*]}"
  exit 1
fi

echo "🔍 Verifica se esiste il tag '$TAG_NAME' in locale..."
if git tag | grep -q "^$TAG_NAME$"; then
  echo "🧹 Rimuovo tag '$TAG_NAME' in locale..."
  git tag -d "$TAG_NAME"
else
  echo "✅ Nessun tag locale con nome '$TAG_NAME'"
fi

echo "🔍 Verifica se esiste il tag '$TAG_NAME' su remoto..."
if git ls-remote --tags origin | grep -q "refs/tags/$TAG_NAME$"; then
  echo "🧹 Rimuovo tag '$TAG_NAME' su remoto..."
  git push --delete origin "$TAG_NAME"
else
  echo "✅ Nessun tag remoto con nome '$TAG_NAME'"
fi

echo "➕ Creo il tag '$TAG_NAME' in locale..."
git tag "$TAG_NAME"

echo "🚀 Pusho il tag '$TAG_NAME' su remoto..."
git push origin "$TAG_NAME"

echo "🧼 Pulizia: rimuovo il tag '$TAG_NAME' in locale dopo il push..."
git tag -d "$TAG_NAME"

echo "✅ Fatto!"
