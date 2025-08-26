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

Este projeto deve ser hospedado em uma **org Salesforce**.

### ⚙️ Configuração Prévia Obrigatória

Este projeto depende criticalmente da existência de campos e valores de lista de seleção (picklist) específicos em sua org Salesforce. Execute os passos abaixo **ANTES de fazer o deploy do código**.

---

### Passo 1: Criar Campos Customizados nos Objetos

**No Objeto Account:**

| Label  | API Name   | Tipo     | Detalhes                 |
|--------|------------|----------|-------------------------|
| Active | Active__c  | Picklist | Valores: No, Yes        |
| CNPJ   | CNPJ__c    | Texto    | Tamanho: 18 caracteres  |

**No Objeto Case (Ocorrência):**

| Label           | API Name        | Tipo        | Detalhes                                       |
|-----------------|----------------|------------|-----------------------------------------------|
| Category        | Category__c     | Picklist   | Valores: Backup, Email, User Management, Internet, Software, Hardware, Printer |
| Date Pause      | DatePause__c    | Data/Hora  | -                                             |
| Date Unpause    | DateUnpause__c  | Data/Hora  | -                                             |
| Email           | Email__c        | Email      | -                                             |
| Finish SIA      | FinishSia__c    | Data/Hora  | -                                             |
| Name            | Name__c         | Texto      | -                                             |
| Surname         | Surname__c      | Texto      | -                                             |
| SIA             | SIA__c          | Número     | Escala: 2, Dígitos: 2                         |
| SIA Response    | SiaResponse__c  | Número     | Escala: 2, Dígitos: 16                        |
| SIA Paused      | SiaPaused__c    | Caixa de seleção | -                                           |
| Start Service   | StartService__c | Caixa de seleção | -                                           |
| Vigency         | Vigency__c      | Picklist   | Valores: Average, High, Low                   |

---

### Passo 2: Configurar Valores de Lista de Seleção em Campos Nativos

O projeto também utiliza os seguintes valores em campos padrões do Salesforce. Atualize os seguintos campos no objeto Case:

**Campo Type (Tipo):**

- Deployment
- Incident
- Preventive
- Problem
- Request

**Campo Origin (Origem):**

- Phone
- Email
- Web
- Web Form

---

### Passo 3: Verificar Permissões

Certifique-se de que o usuário que fará o deploy do código tem permissão de **Personalizar Aplicação (Customize Application)**.

Após o deploy, será necessário atribuir os **Permission Sets** gerados pelo pacote aos usuários finais.

### 🚀 Instalação e Deploy

Após confirmar que TODOS os campos e picklists acima foram criados e configurados, prossiga com a instalação do código:

```bash
# 1. Clone o repositório
git clone https://github.com/mtfreitas-dev/SystemHelpDesk.git
cd SystemHelpDesk

# 2. Autentique-se na sua org de desenvolvimento (alias: myDevOrg)
sfdx auth:web:login -s -a myDevOrg

# 3. Realize o deploy dos metadados
sfdx force:source:deploy -p ./force-app/main/default -u myDevOrg
```

### ❌ Solução de Problemas Comuns

### Erro no Deploy: `"No such column 'Category__c' on entity 'Case'"`

- **Causa:** O campo customizado `Category__c` não foi criado no objeto `Case`.
- **Solução:** Volte ao Passo 1 e crie todos os campos customizados listados.

---

### Erro: `"Invalid picklist value: Hardware in field: Category"`

- **Causa:** O valor `Hardware` não existe na lista de seleção do campo `Category__c`.
- **Solução:** Edite o campo `Category__c` e adicione o valor **missing** à picklist.

---

### App não funciona como esperado após a instalação

- **Causa:** Valores **missing** nos campos nativos `Type` ou `Origin`.
- **Solução:** Verifique e complete a configuração dos picklists nativos no Passo 2.


























- Clonar o repositório
- Criar uma Scratch Org com `sfdx`
- Deployar com `sfdx force:source:push`
- Rodar os testes com `sfdx force:apex:test:run`
- Campos personalizados devem ser criados manualmente via metadata.

Para detalhes, como visualização dos componentes ou paginas lightning, acesse o [📖 Wiki do projeto](https://github.com/mtfreitas-dev/SystemHelpDesk/wiki).

---

## 📄 Licença

Este projeto está sob a licença MIT. Consulte o arquivo `LICENSE` para mais detalhes.
