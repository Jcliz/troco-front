# ADR-0005: Autenticação por sessão opaca em cookie, com proxy no front

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

PRD 7.1: e-mail e senha, logout (RF-06), limite de tentativas (RNF-04), hash forte (RNF-02). `vercel.app` está na Public Suffix List, então `troco-front.vercel.app` e `troco-api.vercel.app` são sites diferentes: um cookie da API seria de terceiros para o navegador e seria bloqueado em vários navegadores, principalmente no Safari do iPhone.

## Decisão

- **Sessão opaca no banco**, não JWT. O login gera um token aleatório de 32 bytes; o cookie guarda o token e o banco guarda só o hash SHA-256 (tabela `sessions`). Logout e exclusão de conta revogam na hora.
- Cookie `troco_session`: `HttpOnly`, `Secure`, `SameSite=Lax`, `Path=/`, validade de 30 dias, renovada a cada uso (janela deslizante).
- **Proxy no front:** o navegador só fala com o domínio do front. O Next.js reescreve `/api/:path*` para a API. Para o navegador, o cookie é do próprio front.
- **CSRF:** `SameSite=Lax` mais a verificação do cabeçalho `Origin` em métodos que alteram dados.
- **Senha:** argon2id (`@node-rs/argon2`), política do RF-02 validada no front e na API.
- **Limite de tentativas:** tabela `login_attempts`; 5 falhas por e-mail em 15 minutos bloqueiam por 15 minutos, e 20 falhas por IP por hora.
- **Recuperação de senha:** token aleatório de uso único, hash no banco, validade de 1 hora. A resposta de "esqueci a senha" é sempre a mesma, exista o e-mail ou não. Trocar a senha encerra todas as sessões.
- **Admin:** campo `role` no usuário (`USER` ou `ADMIN`), definido direto no banco (PRD RF-07).

## Consequências

- A API precisa confiar no cabeçalho `X-Forwarded-For` vindo da Vercel para o limite por IP.
- O MFA da v2 entra como etapa extra antes de criar a sessão, sem mudar o modelo.
