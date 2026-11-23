# PRD: troco

Sistema web de finanças pessoais e controle de gastos

| | |
|---|---|
| **Autor** | João |
| **Status** | **Aprovado v1.2** |
| **Última atualização** | 23/11/2026 |
| **Repositórios** | `troco-front`, `troco-api` |

---

## 1. Visão geral

O **troco** é um sistema web, responsivo para computador e celular, em que a pessoa registra rendas, gastos mensais, gastos sazonais, gastos avulsos e parcelamentos. Com esses dados, o sistema calcula **quanto ela pode gastar no mês (margem de gastos)** e **quanto deveria guardar (reserva)**, e avisa quando algo sai do planejado.

O troco **apenas registra e calcula**. Ele não movimenta dinheiro, não se conecta a bancos e não controla investimentos na v1.

## 2. Problema

- A pessoa não sabe exatamente para onde o dinheiro está indo.
- Não tem visibilidade de onde poderia gastar menos.
- Perde o controle de parcelas e de gastos que só aparecem em certas épocas do ano (IPVA, IPTU, material escolar).
- Não consegue guardar dinheiro de forma consistente.

## 3. Objetivos

1. Mostrar com clareza para onde vai o dinheiro, por categoria e por mês.
2. Calcular automaticamente a margem de gastos do mês e o valor a guardar.
3. Acompanhar parcelamentos e gastos sazonais futuros.
4. Avisar (regras simples na v1) quando o usuário estiver perto de estourar um orçamento ou a margem.
5. Tornar o lançamento rápido, principalmente no início do mês.

## 4. Público-alvo

- **v1:** grupo pequeno de usuários, família e amigos do autor.
- Uso principal: **conta individual**.
- Também é possível ter uma **conta conjunta** (casal/família), ver 7.15.

## 5. Escopo por versão

### v1 (este PRD)

- Cadastro e login com e-mail e senha forte, com recuperação de senha por e-mail.
- Registro manual de rendas (fixas e variáveis) e gastos (mensais, sazonais, avulsos).
- Gastos recorrentes lançados automaticamente todo mês, com revisão dos valores na virada do mês.
- Mês financeiro que começa no dia em que o salário cai, com virada do mês feita pelo usuário (7.8.1).
- Parcelamentos com juros, antecipação e quitação antecipada.
- Formas de pagamento: cartões de crédito (fechamento e vencimento), contas bancárias, dinheiro e Pix.
- Faturas do cartão com registro de pagamento antecipado (total ou parcial).
- Seção de assinaturas, com verificação mensal de uso e da data de renovação.
- Categorias padrão editáveis, com subcategorias.
- Orçamento por categoria com alertas.
- Cálculo da margem de gastos e da reserva.
- Insights por regras simples.
- Alertas no dashboard, por e-mail, por notificação push do navegador e por toast.
- PWA instalável (ícone na tela inicial do celular e do computador, sem lojas de apps).
- Moeda da conta selecionável (padrão BRL), com conversão dos valores.
- Gastos com moeda própria, convertidos para a moeda da conta.
- Conta conjunta, além da conta individual.
- Idiomas: português, inglês e espanhol.
- Conformidade com a LGPD.
- Dashboard de administrador com métricas de uso.

### v2 (planejado)

- Importação de extrato e fatura (CSV, OFX).
- IA para insights (provavelmente Microsoft Agent Framework, ferramenta ainda não definida).
- MFA (autenticação em dois fatores).
- Idiomas: alemão, turco, russo, mandarim, japonês e francês.
- Controle de investimentos.
- Integração com bancos via Open Finance.
- App nativo.
- Infraestrutura de hospedagem mais elaborada (sair da Vercel).

### Fases de entrega da v1

A v1 é entregue em três fases, para ter algo usável cedo. Cada fase vai para produção (Vercel) antes de a próxima começar.

**Fase 1: base e controle mensal**
- Cadastro, login e recuperação de senha (7.1)
- Rendas e gastos mensais, sazonais e avulsos (7.2, 7.3)
- Virada do mês manual, a partir da data do salário (7.8.1)
- Recorrências e revisão das fixas na virada do mês (7.3.1)
- Categorias e subcategorias (7.6)
- Margem de gastos e reserva (7.8, seção 8)
- Dashboard, Lançamentos, Cadastro rápido do mês e Configurações
- Idioma português, moeda BRL, layout responsivo
- LGPD básica: termos, exportação e exclusão de dados (7.13)

**Fase 2: cartões, parcelas e planejamento**
- Formas de pagamento, cartões e faturas com pagamento antecipado (7.5, 7.5.1)
- Parcelamentos com juros, antecipação e quitação (7.4)
- Sazonais com provisão (RF-72)
- Assinaturas (7.14)
- Orçamento por categoria com alertas amarelo e vermelho (7.7)
- Insights por regras simples (7.9)
- Alertas no dashboard e em toast

**Fase 3: compartilhamento, idiomas e alcance**
- Conta conjunta (7.15)
- Multimoeda e gastos com moeda própria (7.11, 7.11.1)
- Inglês e espanhol (RF-101)
- Notificações por e-mail e push (7.10)
- PWA instalável (RNF-09)
- Dashboard de admin (7.12)

### Fora do escopo

- Movimentar dinheiro, fazer pagamentos ou transferências.
- Qualquer função além de registrar gastos e rendas e calcular a partir deles (na v1).

## 6. Conceitos e definições

| Termo | Definição |
|---|---|
| **Renda** | Entrada de dinheiro. Pode ser **fixa** (salário) ou **variável** (freela, extras). O usuário pode ter várias fontes. |
| **Gasto mensal (recorrente)** | Gasto que se repete todo mês (aluguel, internet, assinaturas). Cadastrado uma vez e lançado automaticamente. O valor pode variar um pouco de um mês para outro e é revisado na virada do mês (ver 7.3.1). |
| **Gasto sazonal** | Gasto que acontece em épocas específicas (IPVA, IPTU, material escolar, presentes de Natal). Cadastrado pelo usuário com antecedência. |
| **Gasto avulso** | Gasto do dia a dia sem recorrência (mercado, lanche). Tem categoria própria, mas **soma no total mensal do mês em que foi feito**. |
| **Parcelamento** | Compra com valor total dividido em N parcelas distribuídas nos meses seguintes. |
| **Margem de gastos** | Quanto o usuário ainda pode gastar no mês sem comprometer a reserva. |
| **Reserva (meta de reserva)** | Quanto o usuário quer guardar no mês, como valor fixo ou percentual da renda. |
| **Provisão sazonal** | Parte da renda separada todo mês para cobrir um gasto sazonal futuro. |
| **Mês (mês financeiro)** | Período entre duas viradas do mês. Começa no dia em que o usuário recebeu o salário e termina na véspera da próxima virada. Em todo o sistema, "mês" significa mês financeiro, e não mês do calendário (ver 7.8.1). |
| **Virada do mês** | Ação do usuário que fecha o mês anterior e abre o próximo, informando a data em que o salário foi recebido (ver 7.8.1). |
| **Saldo remanescente** | Dinheiro que sobrou do mês anterior e não foi marcado como investido em reserva. |

## 7. Requisitos funcionais

### 7.1 Conta e autenticação

- **RF-01** Cadastro com nome, e-mail e senha.
- **RF-02** Política de senha forte: **mínimo de 8 caracteres**, contendo pelo menos **1 letra maiúscula, 1 número e 1 caractere especial**. O formulário mostra em tempo real quais regras já foram atendidas.
- **RF-03** Login com e-mail e senha.
- **RF-04** Recuperação de senha por link enviado por e-mail, com expiração.
- **RF-05** Confirmação de e-mail **não é obrigatória** no cadastro: o usuário já entra no sistema logo após se cadastrar. O e-mail precisa ser válido para a recuperação de senha funcionar.
- **RF-06** Logout e encerramento de sessão.
- **RF-07** Perfil de administrador, com acesso ao dashboard de admin. Na v1, o único admin é o autor, definido direto no banco, sem tela para promover admins.

### 7.2 Rendas

- **RF-10** Cadastrar renda com valor, data, descrição, tipo (fixa ou variável) e observação.
- **RF-11** Renda fixa pode ser recorrente e lançada automaticamente todo mês, com revisão do valor na virada do mês (ver 7.3.1).
- **RF-12** Renda variável é lançada quando recebida.
- **RF-13** Múltiplas fontes de renda por usuário.

### 7.3 Gastos

- **RF-20** Cadastrar gasto com: valor, moeda (padrão: a moeda da conta), data, descrição, categoria, subcategoria (opcional), forma de pagamento e observação (útil para exceções à regra).
- **RF-21** Tipo do gasto: mensal (recorrente), sazonal ou avulso.
- **RF-22** Gastos recorrentes são cadastrados uma vez e lançados automaticamente todo mês. A configuração da recorrência fica na tela de **Configurações**.
- **RF-23** Gastos avulsos usam uma categoria específica e entram no total mensal do mês em que ocorreram.
- **RF-24** Gastos sazonais são cadastrados pelo usuário com data prevista e valor estimado.
- **RF-25** Editar e excluir lançamentos.
- **RF-26** Listar e filtrar lançamentos por mês, categoria, tipo e forma de pagamento.

#### 7.3.1 Revisão das despesas fixas na virada do mês

Os valores das despesas fixas quase nunca são exatamente iguais todo mês (ex.: conta de luz, internet com reajuste). Por isso, o lançamento automático não é definitivo até o usuário revisar.

- **RF-27** Na virada do mês (7.8.1), o sistema cria os lançamentos das despesas fixas com status **"a confirmar"**, já preenchidos com o **valor de referência** (por padrão, o valor confirmado no mês anterior).
- **RF-28** Ao abrir o sistema no novo mês, o usuário vê a **revisão das fixas** (dentro da tela de Cadastro rápido do mês): uma lista de todas as fixas com a pergunta "Teve mudança em algum valor?". Cada linha mostra o valor sugerido em um campo editável.
- **RF-29** O usuário pode:
  - **Confirmar tudo** com um clique, se nada mudou;
  - **Alterar o valor** de uma ou mais fixas só para o mês atual;
  - Marcar **"usar este valor nos próximos meses"**, atualizando o valor de referência.
- **RF-29a** Ao alterar um valor, o sistema mostra a diferença em relação ao mês anterior (ex.: "+R$ 4,30, +3,1%").
- **RF-29b** Cada despesa fixa pode ter uma **variação esperada** opcional, com padrão de **±5%** (editável por despesa). Mudanças dentro dessa faixa são aceitas sem destaque. Mudanças acima disso aparecem destacadas na revisão e geram um insight (ex.: "sua conta de luz subiu 18% em relação à média dos últimos 3 meses").
- **RF-29c** Enquanto uma fixa estiver "a confirmar", a margem do mês usa o valor de referência. Depois da confirmação, usa o valor confirmado.
- **RF-29d** Se o usuário não revisar as fixas em até **3 dias** após fazer a virada do mês, o sistema envia um lembrete pelos canais de alerta configurados. A revisão também pode ser feita em qualquer momento depois.
- **RF-29e** O sistema guarda o histórico de valores de cada despesa fixa, para mostrar a evolução e alimentar os insights.
- **RF-29f** O mesmo fluxo vale para **rendas fixas** (salário que muda por horas extras ou descontos, por exemplo).

### 7.4 Parcelamentos

- **RF-30** Cadastrar compra parcelada com valor total, número de parcelas, data da primeira parcela, forma de pagamento e categoria.
- **RF-31** O sistema distribui as parcelas nos meses seguintes.
- **RF-32** Suporte a **juros** (taxa ou valor final informado pelo usuário).
- **RF-33** **Antecipação** de uma ou mais parcelas.
- **RF-34** **Quitação antecipada** do parcelamento, encerrando as parcelas futuras.
- **RF-35** Tela de acompanhamento: parcelas pagas, restantes, valor restante e data de término.

### 7.5 Formas de pagamento

- **RF-40** Cadastrar cartões de crédito com nome, dia de fechamento e dia de vencimento da fatura.
- **RF-41** Gastos no cartão entram na fatura correta conforme a data de fechamento.
- **RF-42** Cadastrar contas bancárias, dinheiro e Pix como formas de pagamento.

#### 7.5.1 Faturas do cartão

- **RF-43** Cada cartão tem uma fatura por mês, com status **aberta**, **fechada**, **paga** ou **paga parcialmente**.
- **RF-44** O usuário pode marcar a fatura como **paga antecipadamente**, informando a data e o valor pago, mesmo antes do fechamento ou do vencimento.
- **RF-45** Pagamento antecipado parcial: o valor pago é abatido da fatura e o restante continua em aberto até o vencimento.
- **RF-46** Se a fatura for paga antes do fechamento e houver compras depois do pagamento, essas compras continuam entrando na mesma fatura como saldo em aberto.
- **RF-47** Fatura paga não gera mais alertas de vencimento.
- **RF-48** Pagar a fatura **não conta como um novo gasto**, porque as compras já foram lançadas quando foram feitas. O pagamento só muda o status da fatura, evitando contar o dinheiro duas vezes.

### 7.6 Categorias

- **RF-50** O sistema vem com categorias padrão (ex.: Moradia, Alimentação, Transporte, Saúde, Educação, Lazer, Assinaturas, Emergência, Investimento, Avulsos, Outros).
- **RF-50a** **Emergência** é para gastos inesperados (ex.: conserto do carro, remédio urgente). Os insights mostram esses gastos separados, para não serem confundidos com descontrole.
- **RF-50b** **Investimento** é para o dinheiro aplicado (ex.: aporte na poupança ou no Tesouro). Lançamentos nessa categoria contam como **reserva guardada** do mês (RF-73), e não como gasto de consumo nos insights.
- **RF-51** O usuário pode adicionar, editar e remover categorias na tela de **Configurações**.
- **RF-52** Cada categoria pode ter **subcategorias** (um nível abaixo da categoria pai). Ex.: Alimentação > Mercado, Restaurante, Delivery.
- **RF-53** A subcategoria é opcional no lançamento. Relatórios, orçamentos e insights funcionam por categoria e, quando houver, por subcategoria.
- **RF-54** O sistema já vem com algumas subcategorias padrão, editáveis como as categorias.

### 7.7 Orçamento por categoria

- **RF-60** Definir limite mensal por categoria (ex.: Lazer até R$ 300).
- **RF-61** Alertas de orçamento por categoria em três níveis:
  - **Amarelo** ao atingir **80%** do limite;
  - **Vermelho** ao atingir **95%** do limite;
  - **Vermelho, "limite ultrapassado"**, ao passar de 100%.
- **RF-62** As cores dos alertas são as mesmas em todos os canais em que há cor (dashboard, toast e e-mail).

### 7.8 Margem de gastos e reserva

- **RF-70** Meta de reserva configurável como **valor fixo** ou **percentual da renda**, à escolha do usuário.
- **RF-71** Cálculo da margem do mês (ver [seção 8](#8-regras-de-cálculo)).
- **RF-72** Provisão sazonal: para cada gasto sazonal cadastrado, o sistema sugere quanto guardar por mês até a data prevista e exibe um aviso. Se não houver gasto sazonal cadastrado, nada é provisionado.
- **RF-73** No fechamento do mês (feito na virada, 7.8.1), o usuário pode marcar quanto da sobra foi investido em reserva.
- **RF-74** A sobra não marcada como investida passa para o mês seguinte como saldo remanescente.
- **RF-75** Se o usuário estourar a margem, o valor a guardar no mês seguinte **aumenta** para compensar.
- **RF-76** Lançamentos na categoria **Investimento** abatem da reserva do mês, e não da margem. Se o total aportado passar da reserva do mês, o excedente sai da margem (ver 8.4).

#### 7.8.1 Virada do mês

O salário não cai sempre no mesmo dia, então o mês financeiro não segue o calendário e não vira sozinho. Quem vira o mês é o usuário.

- **RF-77** O sistema tem um botão **"Virar o mês"** (no Dashboard e no Cadastro rápido do mês) que fecha o mês atual e abre o próximo.
- **RF-78** Ao clicar, o usuário informa a **data em que recebeu o salário** (padrão: hoje, editável). Essa data é o primeiro dia do novo mês, e a véspera dela é o último dia do mês que está sendo fechado. A data não pode ser anterior ao início do mês atual nem futura.
- **RF-79** O fluxo da virada, em sequência:
  1. **Fechamento do mês anterior:** mostra a sobra (ou o estouro) e pergunta quanto foi investido em reserva (RF-73).
  2. **Abertura do novo mês:** cria os lançamentos das fixas e rendas fixas "a confirmar" (RF-27).
  3. Leva para o **Cadastro rápido do mês**, começando pela revisão das fixas (7.3.1) e pela verificação das assinaturas (RF-136, RF-139).
- **RF-79a** Cada lançamento pertence ao mês financeiro que contém a sua data. Compras no cartão contam no mês da **data da compra**, e não no mês do vencimento da fatura. Cada parcela de um parcelamento conta em um mês, a partir do mês da primeira parcela.
- **RF-79b** No primeiro acesso, o usuário informa a data em que recebeu o último salário, que vira o início do seu primeiro mês.
- **RF-79c** Se o mês atual estiver aberto há mais de **35 dias**, o sistema lembra o usuário pelos canais de alerta: "Já recebeu o salário? Vire o mês."
- **RF-79d** O usuário pode corrigir a data de início do mês atual (se informou errado) e pode desfazer a última virada, enquanto o novo mês ainda não tiver lançamentos além dos criados automaticamente.
- **RF-79e** Lançamentos editados ou incluídos em um mês já fechado recalculam a sobra, o saldo remanescente e a compensação de estouro dos meses seguintes.

### 7.9 Insights (v1: regras simples)

- **RF-80** Comparação entre meses por categoria (ex.: "você gastou 40% a mais com Lazer que no mês passado").
- **RF-81** Ranking das categorias que mais cresceram.
- **RF-82** Aviso de proximidade do limite de categoria e da margem.
- **RF-83** Aviso de gasto sazonal se aproximando e de provisão em atraso.
- **RF-84** Sugestão de onde cortar com base nas categorias que mais cresceram.

### 7.10 Notificações e alertas

- **RF-90** Canais: dashboard, e-mail, notificação push do navegador (Web Push) e toast no sistema.
- **RF-91** O usuário escolhe em **Configurações** quais alertas recebe e por qual canal.

### 7.11 Moeda e idioma

- **RF-100** Dropdown para escolher a moeda da conta. Padrão BRL. Moedas disponíveis na v1: BRL, USD, EUR, ARS, GBP, CLP, UYU e MXN.
- **RF-100a** Trocar a moeda da conta **converte todos os valores e muda o símbolo**. A conversão usa a cotação da data de cada lançamento, para o histórico não ficar distorcido.
- **RF-100b** O sistema guarda sempre o valor original e a moeda original de cada lançamento, então trocar a moeda de volta não perde precisão.
- **RF-100c** Antes de trocar, o sistema mostra uma confirmação explicando que os valores serão convertidos.

#### 7.11.1 Gastos com moeda própria

- **RF-103** Cada gasto pode ser lançado em uma moeda diferente da moeda da conta (ex.: compra em dólar numa viagem).
- **RF-104** O sistema converte para a moeda da conta usando a cotação da data do gasto, buscada automaticamente em uma API de cotação.
- **RF-105** O usuário pode ajustar o valor convertido manualmente (ex.: para bater com o valor real cobrado na fatura, com IOF e spread).
- **RF-106** O lançamento mostra os dois valores: original (ex.: US$ 50,00) e convertido (ex.: R$ 275,40), com a cotação usada.
- **RF-107** Cálculos de margem, orçamento e insights usam sempre o valor convertido.
- **RF-101** Interface traduzida em português (padrão), inglês e espanhol.
- **RF-102** Formatação de números, datas e moeda conforme idioma e moeda escolhidos.

### 7.12 Administração

- **RF-110** Dashboard de admin com: quantidade de lançamentos criados, usuários ativos, frequência de uso e evolução no tempo.
- **RF-111** O admin vê apenas métricas agregadas, nunca valores ou lançamentos individuais dos usuários (LGPD).

### 7.13 LGPD e privacidade

- **RF-120** Termos de uso e política de privacidade aceitos no cadastro.
- **RF-121** O usuário pode exportar todos os seus dados.
- **RF-122** O usuário pode excluir a conta e todos os seus dados. A exclusão é imediata e definitiva, confirmada com a senha.
- **RF-123** Coletar apenas os dados necessários ao funcionamento.

### 7.14 Assinaturas

Seção própria para acompanhar serviços recorrentes como Netflix, Spotify, Disney+, Amazon Prime, apps e academias.

- **RF-130** Cadastrar assinatura com nome do serviço, valor, ciclo de cobrança (mensal, trimestral ou anual), dia da cobrança, forma de pagamento e data de início.
- **RF-131** Status da assinatura: **ativa**, **em teste grátis**, **pausada** ou **cancelada**. Só as ativas entram nos cálculos.
- **RF-132** Assinaturas mensais entram automaticamente como despesa fixa, seguindo a revisão da virada do mês (7.3.1).
- **RF-133** Assinaturas anuais ou trimestrais geram uma **provisão mensal**, da mesma forma que os gastos sazonais, para o valor não pegar de surpresa no mês da renovação.
- **RF-134** Resumo da seção: total gasto por mês e por ano com assinaturas e quantidade de assinaturas ativas.
- **RF-135** Alertas: fim do teste grátis, renovação de assinatura anual se aproximando (**7 dias antes**) e aumento de preço.
- **RF-139** Toda virada do mês (7.8.1), junto com a verificação de uso (RF-136), o sistema pede que o usuário **confirme ou informe a data de renovação** de cada assinatura ativa, já preenchida com a data atual e editável. Os alertas de renovação usam essa data.
- **RF-136** Verificação de uso: toda virada do mês (7.8.1), junto com a revisão das fixas, o sistema pergunta para cada assinatura ativa **"Você usou [serviço] no mês passado?"**.
  - Se **sim**, pede que o usuário explique no que e como usou (campo de texto curto, ex.: "assisti 2 séries", "playlist da academia").
  - Se **não**, registra o mês sem uso.
- **RF-137** Insight: assinatura sem uso por **75 dias** gera a sugestão de cancelamento, mostrando quanto o usuário economizaria por ano.
- **RF-138** O histórico de uso fica visível na tela da assinatura.

### 7.15 Conta conjunta

- **RF-140** Um usuário pode criar uma **conta conjunta** e convidar outras pessoas por e-mail (ex.: casal ou família).
- **RF-141** Cada pessoa continua com sua conta individual. A conta conjunta é um espaço separado, e o usuário alterna entre as duas no menu.
- **RF-142** Na conta conjunta, todos os membros veem e lançam rendas e gastos, e ela tem margem, reserva, orçamentos, parcelamentos, sazonais e assinaturas próprios.
- **RF-143** Cada lançamento registra **quem lançou** e **quem pagou**.
- **RF-147** Divisão de gastos: cada gasto da conta conjunta tem um **responsável**, que pode ser:
  - **um membro específico** (ex.: só o João arca);
  - **dividido entre membros** (todos ou alguns, em partes iguais por padrão, com opção de definir percentual ou valor por pessoa);
  - **"a ver"**, quando ainda não foi decidido quem paga.
- **RF-148** A divisão é **editável** a qualquer momento por qualquer membro.
- **RF-149** Gastos "a ver" ficam numa lista própria para os membros decidirem juntos. Quando decidem, um membro marca quem é o responsável (ou a divisão), e o gasto sai da lista.
- **RF-150** Gastos "a ver" acumulados geram alerta para os membros (ex.: "3 gastos aguardando definição").
- **RF-151** Cada membro vê um resumo do mês: quanto é responsabilidade sua, quanto já pagou e quanto falta.
- **RF-152** A parte de cada membro em um gasto da conta conjunta **desconta automaticamente da conta individual dele** e entra em todos os cálculos de margem, reserva e orçamento, porque é dinheiro que saiu do bolso dele. Na conta individual, esses valores aparecem como "gastos da conta conjunta", com link para o gasto original.
- **RF-153** Gastos "a ver" não descontam da conta individual de ninguém até o responsável ser definido. Quando é definido, o valor passa a descontar no mês do gasto.
- **RF-154** Para evitar contagem dupla, o usuário não precisa lançar na conta individual uma transferência para a conta conjunta.
- **RF-144** Papéis: **dono** (convida, remove membros e exclui a conta conjunta) e **membro** (lança e edita).
- **RF-145** Um membro pode sair da conta conjunta a qualquer momento. Seus lançamentos na conta conjunta continuam lá.
- **RF-146** Pela LGPD, membros da conta conjunta não veem a conta individual um do outro.

## 8. Regras de cálculo

Nesta seção, "mês" é sempre o mês financeiro (7.8.1): do dia da virada até a véspera da próxima. "Meses restantes" (8.3) conta viradas futuras, estimadas pelo calendário.

### 8.1 Base do mês

```
base_do_mes = renda_recebida_no_mes + saldo_remanescente_do_mes_anterior
```

### 8.2 Meta de reserva do mês

```
se tipo_meta = "fixo":       reserva_meta = valor_fixo
se tipo_meta = "percentual": reserva_meta = renda_recebida_no_mes × percentual

reserva_do_mes = reserva_meta + compensacao_de_estouro_do_mes_anterior
```

### 8.3 Provisão sazonal

Para cada gasto sazonal cadastrado e ainda não ocorrido:

```
provisao_mensal = (valor_estimado − valor_ja_provisionado) / meses_restantes_ate_a_data
provisao_sazonal_do_mes = soma das provisões mensais
```

Sem gastos sazonais cadastrados, `provisao_sazonal_do_mes = 0`.

Assinaturas anuais e trimestrais ativas entram nessa mesma soma, usando a data da próxima renovação (RF-133).

### 8.4 Margem de gastos

```
margem_do_mes = base_do_mes
              − gastos_fixos_do_mes
              − parcelas_do_mes
              − provisao_sazonal_do_mes
              − reserva_do_mes
              − minha_parte_dos_gastos_da_conta_conjunta

aportes_do_mes = soma dos lançamentos na categoria Investimento no mês
excedente_de_aporte = max(0, aportes_do_mes − reserva_do_mes)

margem_disponivel = margem_do_mes
                  − gastos_avulsos_e_variaveis_ja_lancados
                  − excedente_de_aporte
```

Aportes até o valor da reserva do mês não reduzem a margem, porque já estão descontados em `reserva_do_mes` (RF-76).

### 8.5 Fechamento do mês

```
sobra = base_do_mes − total_gasto − provisao_sazonal_do_mes

se sobra ≥ 0:
    investido = valor que o usuário marcar como investido em reserva na virada (padrão 0)
    saldo_remanescente_do_proximo_mes = sobra − investido

se o usuário estourou a margem (margem_disponivel < 0):
    compensacao_de_estouro_do_proximo_mes = |margem_disponivel|
```

> Exemplo: renda de R$ 5.000, sobra de R$ 200 do mês anterior, fixos de R$ 2.000, parcelas de R$ 600, IPVA de R$ 1.200 em 6 meses (R$ 200/mês) e meta de reserva de 10% (R$ 500).
> Margem = 5.200 − 2.000 − 600 − 200 − 500 = **R$ 1.900** para gastos avulsos e variáveis.

## 9. Telas da v1

1. **Login**
2. **Cadastro**
3. **Recuperar senha**
4. **Dashboard:** margem disponível, reserva do mês, gastos por categoria, próximas parcelas, próximos sazonais, alertas e insights.
5. **Lançamentos:** lista com filtros, criar, editar e excluir rendas e gastos.
6. **Cadastro rápido do mês:** tela que reúne tudo em um só lugar para facilitar o lançamento do início do mês (rendas, fixos do mês, parcelas, sazonais e meta de reserva), com revisão e confirmação. Começa pela **revisão das despesas e rendas fixas** (7.3.1), com os valores do mês anterior já preenchidos e editáveis.
7. **Parcelamentos:** acompanhamento, antecipação e quitação.
8. **Cartões e faturas:** faturas por cartão, status e registro de pagamento antecipado (total ou parcial).
9. **Assinaturas:** lista de assinaturas, status, custo mensal e anual e próximas renovações.
10. **Sazonais:** cadastro e acompanhamento das provisões.
11. **Orçamento por categoria**
12. **Configurações:** recorrências, categorias, formas de pagamento, meta de reserva, moeda, idioma, notificações, exportar e excluir dados.
13. **Conta conjunta:** membros e convites, lançamentos da conta conjunta, divisão de gastos, lista de gastos "a ver" e resumo de responsabilidade de cada membro.
14. **Admin:** métricas de uso.

## 10. Requisitos não funcionais

| ID | Requisito |
|---|---|
| **RNF-01** | Responsivo, com boa experiência em computador e celular, tudo pelo navegador. |
| **RNF-02** | Senhas armazenadas com hash forte (bcrypt ou argon2). |
| **RNF-03** | Tráfego somente via HTTPS. |
| **RNF-04** | Proteção contra força bruta no login (limite de tentativas). |
| **RNF-05** | Conformidade com a LGPD em todas as versões. |
| **RNF-06** | Valores monetários armazenados como decimal ou inteiro em centavos, nunca ponto flutuante. |
| **RNF-07** | Textos da interface externalizados para tradução (i18n). |
| **RNF-08** | Backup regular do banco de dados. |
| **RNF-09** | PWA instalável: manifesto (nome, ícone, cores) e service worker, instalável pelo navegador no Android, iPhone e computador, sem publicação em App Store ou Play Store. |

## 11. Stack e arquitetura

| Camada | Escolha |
|---|---|
| **Front (`troco-front`)** | React + TypeScript + shadcn/ui (Tailwind) com **Next.js** |
| **API (`troco-api`)** | Node.js + TypeScript com **NestJS** |
| **ORM** | **Prisma** |
| **Banco** | PostgreSQL no **Neon** (plano gratuito) |
| **Hospedagem v1** | Front e API na **Vercel** (plano Hobby, gratuito) |
| **Domínio v1** | Subdomínio gratuito da Vercel (`*.vercel.app`). Domínio próprio fica para depois (ponto 9 da seção 13). |
| **Tarefas agendadas** | Vercel Cron, uma vez por dia (lembretes de revisão das fixas, de virada do mês, de renovação de assinaturas). A virada do mês em si é manual (7.8.1). |
| **E-mail** | Enquanto não houver domínio próprio: **SMTP do Gmail** (conta dedicada ao troco, com senha de app). Com domínio próprio: **Resend** (plano gratuito). O código usa uma interface única de envio, então a troca é só de configuração. |
| **Cotação de moedas** | API gratuita de cotação (ex.: AwesomeAPI, que cobre o real e o peso argentino) |
| **i18n** | ex.: next-intl |

Sobre Next.js: é uma boa escolha aqui. Traz rotas, layouts, otimização e bom suporte a i18n e PWA, e é a plataforma nativa da Vercel. Como a regra de negócio fica na `troco-api`, o Next.js será usado principalmente como front, consumindo a API.

Sobre o Prisma: encaixa bem com NestJS e TypeScript, gera tipos a partir do esquema do banco, tem migrações simples e suporta o tipo `Decimal`, importante para valores monetários (RNF-06).

Sobre a hospedagem: a v1 é só para testes em produção, então a escolha é a mais barata e simples. Vercel, Neon e Resend têm planos gratuitos e se integram entre si, e tudo fica em um painel só. A migração para uma infraestrutura mais robusta fica para a v2.

> Observação: notificação push no navegador funciona em computador e Android sem instalar nada. No iPhone, o Web Push só funciona com o PWA instalado na tela inicial ("Adicionar à Tela de Início" no Safari). O sistema deve orientar o usuário de iPhone a instalar o PWA para receber push.

## 12. Métricas de sucesso

- Quantidade de lançamentos criados (por usuário e total).
- Uso geral do sistema: usuários ativos por semana e por mês e frequência de acesso.
- Todas exibidas no **dashboard de admin**.

## 13. Pontos de confirmação futura

| # | Ponto | Versão |
|---|---|---|
| 1 | **Importação** de extrato e fatura (CSV, OFX) | v2 |
| 2 | **IA para insights** (Microsoft Agent Framework ou outra) | v2 |
| 3 | **MFA** | v2 |
| 4 | **Novos idiomas**: alemão, turco, russo, mandarim, japonês, francês | v2 |
| 5 | **Infraestrutura** além da Vercel | v2 |
| 6 | **Controle de investimentos** | v2 |
| 7 | **Open Finance** | v2 |
| 8 | **App nativo** | v2 |
| 9 | **Domínio próprio** (ex.: troco.app), trocando o `*.vercel.app`. Com ele, o e-mail passa do Gmail para o Resend com domínio verificado | A definir |
| 10 | **Mês financeiro da conta conjunta**: os membros recebem salário em dias diferentes. Sugestão: a conta conjunta usa o mês do calendário, e a parte de cada membro entra no mês financeiro individual dele pela data do gasto | Fase 3 |

### Decisões já tomadas (antes pendentes)

- Subcategorias: entram na v1 (7.6).
- Gastos com moeda própria: entram na v1 (7.11.1).
- Conta conjunta: entra na v1, com divisão de gastos editável, gastos divididos e gastos "a ver" (7.15). A parte de cada membro desconta da margem da conta individual dele (RF-152).
- API em NestJS com Prisma (seção 11).
- Hospedagem v1: Vercel + Neon, a opção gratuita mais simples (seção 11).
- Senha: mínimo de 8 caracteres, 1 maiúscula, 1 número e 1 especial (RF-02).
- Confirmação de e-mail no cadastro: não obrigatória (RF-05).
- Moedas da v1: BRL, USD, EUR, ARS, GBP, CLP, UYU e MXN (RF-100).
- Troca da moeda da conta converte os valores e muda o símbolo (RF-100a).
- Revisão das fixas: lembrete após 3 dias e variação esperada padrão de ±5% (RF-29b, RF-29d).
- Assinatura sem uso: pergunta mensal de uso com explicação, e sugestão de cancelamento após 75 dias sem uso (RF-136, RF-137).
- Assinaturas: aviso de renovação 7 dias antes, e confirmação mensal da data de renovação (RF-135, RF-139).
- Orçamento por categoria: alerta amarelo em 80% e vermelho em 95% (RF-61).
- Categorias padrão incluem Emergência e Investimento; a seção de streaming passa a se chamar Assinaturas (RF-50).
- v1 dividida em 3 fases de entrega (seção 5).
- Domínio na v1: subdomínio gratuito da Vercel; domínio próprio é ponto de confirmação futura (seção 11, ponto 9).
- Mês financeiro começa no dia do salário, e a virada é manual por um botão, informando a data do salário (7.8.1).
- Compra no cartão conta no mês da compra, não no da fatura (RF-79a).
- Aportes em Investimento abatem da reserva; o excedente sai da margem (RF-76, 8.4).
- Exclusão de conta imediata e definitiva, confirmada com senha (RF-122).
- Admin único na v1, definido direto no banco (RF-07).
- E-mail sem domínio próprio: SMTP do Gmail, porque o Resend só envia para terceiros com domínio verificado (seção 11).

## 14. Prazo

Projeto pessoal, sem data definida para a v1.
