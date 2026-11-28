#!/usr/bin/env bash
# Antes do Claude encerrar a resposta, roda lint e typecheck se ele mudou código.
# Se falhar, sai com 2: o Claude Code devolve o erro e o Claude continua corrigindo.
set -u
input="$(cat)"
active="$(printf '%s' "$input" | node -e 'let d="";process.stdin.on("data",c=>d+=c).on("end",()=>{try{process.stdout.write(String(JSON.parse(d).stop_hook_active===true))}catch{process.stdout.write("false")}})' 2>/dev/null)"
[ "$active" = "true" ] && exit 0   # já está corrigindo por causa deste hook: não repetir

cd "${CLAUDE_PROJECT_DIR:-.}" || exit 0
[ -f package.json ] && [ -d node_modules ] || exit 0
git status --porcelain 2>/dev/null | grep -Eq '\.(ts|tsx|js|mjs|cjs)$' || exit 0

for script in lint typecheck; do
  if ! out="$(pnpm -s "$script" 2>&1)"; then
    printf 'pnpm %s falhou. Corrija antes de terminar:\n%s\n' "$script" "$(printf '%s' "$out" | tail -n 40)" >&2
    exit 2
  fi
done
exit 0
