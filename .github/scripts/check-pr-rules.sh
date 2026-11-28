#!/usr/bin/env bash
# Regras de .claude/rules/git.md conferidas em todo PR:
# nome da branch, título em Conventional Commits e commits sem assinatura de agente.
set -u
fail=0

types='feat|fix|docs|chore|refactor|test'
if ! printf '%s' "$BRANCH" | grep -Eq "^($types)/[a-z0-9]+(-[a-z0-9]+){1,6}$"; then
  echo "::error::Branch '$BRANCH' fora do padrão <tipo>/<resumo-em-inglês> (ex.: feat/api-07-month-turnover), sem prefixo de ferramenta nem sufixo aleatório."
  fail=1
fi

if ! printf '%s' "$TITLE" | grep -Eq '^(feat|fix|docs|chore|refactor|test|perf|build|ci|style|revert)(\([a-z0-9-]+\))?!?: [^ ].*$'; then
  echo "::error::Título do PR fora de Conventional Commits (ex.: feat(periods): add month turnover endpoint). Ele vira a mensagem do squash."
  fail=1
fi

signed="$(git log --format='%H %an <%ae>%n%B' "$BASE_SHA..$HEAD_SHA" | grep -Ei 'co-authored-by|claude-session|generated (with|by) \[?claude code|noreply@anthropic\.com' || true)"
if [ -n "$signed" ]; then
  echo "::error::Há commit com assinatura de agente. O autor é só o João, sem Co-Authored-By nem Claude-Session:"
  printf '%s\n' "$signed"
  fail=1
fi

[ "$fail" -eq 0 ] && echo "Branch, título e commits dentro das regras."
exit "$fail"
