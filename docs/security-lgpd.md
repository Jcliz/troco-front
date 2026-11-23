# Segurança e LGPD

## Autenticação e sessão

Resumo do [ADR-0005](adr/0005-autenticacao-sessao-em-cookie.md): sessão opaca em cookie `HttpOnly`, `Secure`, `SameSite=Lax`, servida pelo domínio do front via proxy; senha em argon2id; limite de tentativas no banco; token de recuperação de uso único com 1 hora de validade; troca de senha encerra todas as sessões.

## Autorização

- Toda rota financeira passa pelo `LedgerAccessGuard`: o usuário precisa ser membro do ledger.
- Toda consulta Prisma de dado financeiro filtra por `ledgerId`. Buscar por `id` sozinho é proibido (evita acessar dado de outra conta trocando o ID).
- Rotas de admin (Fase 3) exigem `role = ADMIN` e só devolvem agregados (RF-111).

## Cabeçalhos e transporte

- HTTPS sempre (a Vercel força).
- API: `helmet`, CORS fechado (só o domínio do front, para chamadas fora do proxy, como ferramentas de teste em preview).
- Front: CSP básica, `X-Frame-Options: DENY`, `Referrer-Policy: strict-origin-when-cross-origin`.

## LGPD

| Tema | Como o troco atende |
|---|---|
| Minimização (RF-123) | Só nome, e-mail, senha (hash) e dados que o usuário lança. Sem CPF, telefone ou endereço. IP só como hash, temporário, para o limite de tentativas |
| Consentimento (RF-120) | Aceite dos termos e da política no cadastro, com versão e data guardadas |
| Acesso e portabilidade (RF-121) | `GET /v1/me/export` devolve um JSON com tudo |
| Exclusão (RF-122) | `DELETE /v1/me`, imediata e definitiva, com senha. Apaga usuário, sessões, ledgers pessoais e tudo que pende deles (cascade). Na Fase 3, lançamentos feitos por ele em conta conjunta ficam, sem o vínculo de autor (RF-145) |
| Logs | Sem dados pessoais nem valores; Sentry sem PII ([ADR-0015](adr/0015-observabilidade.md)) |
| Backups (RNF-08) | Histórico de restauração do Neon (plano gratuito). A política de privacidade informa que cópias de backup expiram sozinhas no prazo do provedor |
| Admin | Só métricas agregadas (RF-111) |

## Pontos em aberto

- Texto dos termos de uso e da política de privacidade (antes do primeiro deploy de produção).
- MFA (v2).
