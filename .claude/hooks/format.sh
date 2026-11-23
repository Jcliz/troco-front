#!/usr/bin/env bash
# Formata com Prettier o arquivo que o Claude acabou de editar.
# Silencioso e tolerante: se o Prettier ainda não estiver instalado, não faz nada.
set -u
input="$(cat)"
file="$(printf '%s' "$input" | node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{try{const j=JSON.parse(d);process.stdout.write((j.tool_input&&(j.tool_input.file_path||j.tool_input.path))||"")}catch{}})' 2>/dev/null)"
[ -z "$file" ] && exit 0
case "$file" in
  *.ts|*.tsx|*.js|*.mjs|*.cjs|*.json|*.md|*.yml|*.yaml|*.css) ;;
  *) exit 0 ;;
esac
prettier="$CLAUDE_PROJECT_DIR/node_modules/.bin/prettier"
[ -x "$prettier" ] || exit 0
"$prettier" --write --log-level=silent "$file" >/dev/null 2>&1 || true
exit 0
