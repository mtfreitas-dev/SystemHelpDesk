# Sistema de HelpDesk

Sistema de Help Desk desenvolvido com Lightning Web Components (LWC) e Apex, executado na plataforma Salesforce. Ele permite o registro, visualização, edição e acompanhamento de chamados (tickets), com monitoramento de SLAs.

## 🚀 Funcionalidades

🕒 Visualização de SLA – Acompanha o tempo restante ou excedido do SLA para cada chamado.

➕ Criação de chamados – Formulário interativo com campos obrigatórios, categorias e envio.

📝 Formulário Web - Formulário Web para criação de chamados utilizando Web-To-Case.

✏️ Edição de chamados – Permite atualizar informações, status, datas e observações dos tickets.

⚙️ Automação com Triggers – Regras automáticas executadas durante a criação ou atualização de tickets.

🧪 Cobertura com Classes de Teste – Verificação de integridade e cobertura de código para deploy seguro. 


## 🛠️ Tecnologias Utilizadas

Salesforce Lightning Web Components (LWC)

Apex (triggers, classes de serviço, filas assíncronas)

SOQL/SOSL para consultas

Salesforce Objects (Case, objetos customizados para SLA, Pausa, etc.)

GitHub Wiki para documentação

## 📁 Estrutura do projeto

📦 Lightning Web Components (LWC)

| Componente      | Descrição                                                      |
| --------------- | -------------------------------------------------------------- |
| `SlaViewer`     | Exibe o tempo de SLA restante com barra de progresso dinâmica. |
| `TicketCreator` | Formulário de criação de chamados.                             |
| `TicketEditor`  | Permite editar dados dos tickets existentes.                   |

⚙️ Apex (Backend)
📜 Classes Apex

| Classe                | Função                                                                       |
| --------------------- | ---------------------------------------------------------------------------- |
| `CalcSLA`             | Classe `Queueable` que calcula e atualiza o tempo restante de SLA dos casos. |
| `EmailServiceHandler` | Responsável por processar chamados recebidos por e-mail (se houver).         |
| `TicketManager`       | Executa regras de negócio e manipulação de dados dos tickets.                |

                                                                                  |
