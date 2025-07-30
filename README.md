# 🛠️ Sistema de Help Desk - Salesforce

Aplicação desenvolvida com **Lightning Web Components (LWC)** e **Apex**, hospedada na plataforma **Salesforce**, para **gerenciamento de chamados (tickets)** com controle de SLA e automações personalizadas.

> 💼 Este projeto foi desenvolvido com foco em boas práticas de desenvolvimento na Salesforce, cobrindo lógica assíncrona, triggers, cobertura de testes e componentes modernos com LWC.

---

## 🚀 Funcionalidades Principais

- 🕒 **Visualização de SLA** — Barra de progresso dinâmica mostra o tempo restante ou estourado.
- ➕ **Criação de chamados** — Formulário interativo com campos obrigatórios e categorização.
- 📝 **Formulário Web** — Integração com Web-to-Case para submissão pública de chamados.
- ✏️ **Edição de chamados** — Permite atualizar status, datas e observações.
- ⚙️ **Automação com Triggers** — Lógicas disparadas automaticamente ao criar ou atualizar registros.
- 🧪 **Cobertura com Classes de Teste** — Para garantir deploys seguros e lógicos consistentes.

---

## 🧑‍💻 Tecnologias Utilizadas

- Salesforce Lightning Web Components (LWC)
- Apex (triggers, classes, queueable, schedulable)
- SOQL / SOSL
- Salesforce Objects (Case, custom SLA, Pausa, etc.)
- GitHub Wiki para documentação

---

## 📁 Estrutura do Projeto

### 📦 Lightning Web Components (LWC)

| Componente      | Descrição                                                  |
|-----------------|------------------------------------------------------------|
| `SlaViewer`     | Exibe o tempo restante de SLA com barra de progresso.      |
| `TicketCreator` | Formulário para criação de chamados.                       |
| `TicketEditor`  | Edição de chamados existentes.                             |

### ⚙️ Classes Apex

| Classe                | Função                                                                            |
|-----------------------|-----------------------------------------------------------------------------------|
| `CalcSLA`             | Classe Queueable que calcula e atualiza o tempo restante de SLA.                 |
| `SchedableSLAUpdate`  | Agendador para execução periódica da atualização do SLA.                         |
| `CaseControl`         | Realiza operações de consulta e atualização de dados dos tickets.                |

### 🔁 Triggers

| Trigger          | Evento                        | Função                                                                 |
|------------------|-------------------------------|------------------------------------------------------------------------|
| `CaseTrigger`    | before insert, before update  | Calcula SLA, valida campos obrigatórios e controla atualizações.       |
| `AccountTrigger` | before insert                 | Valida CNPJ, evitando duplicações.                                     |
| `ContactTrigger` | before insert, before update  | Valida e-mail, impedindo duplicações e atualizações indevidas.         |

### 🌐 Integração Web-to-Case

O sistema permite a criação de chamados por meio de um formulário público na web, utilizando o recurso Web-to-Case, integrado diretamente à plataforma Salesforce.

- ✅ Funcionalidades Implementadas

- 📥 Submissão de chamados públicos via formulário externo

- 🔐 Validação de campos obrigatórios

- 📝 Mapeamento para campos personalizados no objeto Case

- 🔄 Gatilhos automáticos para cálculo de SLA e demais lógicas após a criação do chamado

---

## 📱 Interface Lightning Customizada

O sistema está integrado em um **Aplicativo personalizado no Salesforce**, com páginas Lightning criadas via **Lightning App Builder** para oferecer uma experiência rica e orientada ao usuário final.

### 📂 Aplicativo Lightning

- Criado para agrupar os componentes do sistema HelpDesk em uma interface unificada.
- Navegação simplificada entre a página inicial, registros de chamados e outras funcionalidades.

### 🏠 Página Inicial (Home)

- Contém:
  - 📊 **Dashboard Salesforce** para visualização geral dos chamados (status, prazos, etc.).
  - ⚙️ Dois componentes **Lightning Web Components (LWC)** integrados à página:
    - Um para **visualização resumida dos SLAs ativos**.
    - Outro para **criação rápida de chamados**.

### 🔍 Página de Visualização de Registro (Case)

- Customização da página de detalhes dos chamados (`Case`), incluindo:
  - Campos reordenados e destacados para facilitar a leitura.
  - Inclusão de um **LWC personalizado** que mostra informações avançadas do SLA ou histórico do chamado.

### 🎨 Recursos Visuais e Experiência

- Layout adaptado para facilitar o uso por atendentes e supervisores.
- Integração total entre **dados do Salesforce** e os **componentes LWC**, garantindo performance e interatividade.

---

## 🧪 Classes de Teste

Cobertura de código com foco em garantir a integridade da lógica e conformidade para deploys.

| Classe de Teste               | Objetivo                                                                                         |
|------------------------------|--------------------------------------------------------------------------------------------------|
| `testCalcSla`                | Testa o cálculo de SLA e valida campos obrigatórios.                                             |
| `testCaseControl`            | Garante o funcionamento do controller de criação e edição de chamados.                          |
| `testCaseTrigger`            | Verifica o comportamento da trigger ao inserir e atualizar casos.                               |
| `testAccountTrigger`         | Testa a trigger de Account com foco na validação de CNPJ.                                       |
| `testContactTrigger`         | Testa validação de e-mails e comportamento da trigger de Contact.                              |
| `testQueueable`              | Testa o processamento assíncrono com lógica Queueable.                                          |
| `testScheduableSlaUpdate`    | Testa a execução e os efeitos do agendamento com Schedulable.                                   |

---

## 📌 Como Executar

> Este projeto está hospedado em uma **org Salesforce**. Você pode:

- Clonar o repositório
- Criar uma Scratch Org com `sfdx`
- Deployar com `sfdx force:source:push`
- Rodar os testes com `sfdx force:apex:test:run`
- Campos personalizados devem ser criados manualmente via metadata.

Para detalhes, como visualização dos componentes ou paginas lightning, acesse o [📖 Wiki do projeto](https://github.com/mtfreitas-dev/SystemHelpDesk/wiki).

---

## 📄 Licença

Este projeto está sob a licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.
