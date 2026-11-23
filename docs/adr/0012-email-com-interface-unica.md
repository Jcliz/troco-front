# ADR-0012: E-mail por interface única: Gmail agora, Resend depois

- **Status:** Aceito
- **Data:** 2026-11-23

## Contexto

Sem domínio próprio, o Resend só envia para o e-mail do dono da conta. A recuperação de senha precisa funcionar para todos (PRD seção 11).

## Decisão

- Interface `Mailer` com um método `send({ to, subject, html, text })`.
- Implementações: `SmtpMailer` (nodemailer) para o **Gmail** em produção agora e para o **Mailpit** (Docker) em desenvolvimento; `ResendMailer` quando houver domínio. A escolha é pela variável `MAIL_DRIVER`.
- Templates em React Email, com texto alternativo, a partir da Fase 1.

## Consequências

- O Gmail tem limite de cerca de 500 envios por dia, suficiente para a v1.
- Na Fase 1 só existe o e-mail de recuperação de senha. Alertas por e-mail são Fase 3.
