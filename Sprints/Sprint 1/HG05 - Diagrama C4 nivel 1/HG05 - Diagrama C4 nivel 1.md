# 🏗️ **HG05 - Diagrama C4 Nível 1 (Contexto)**

**Sistema:** Plataforma de Processamento na Nuvem - Gráfica Ltda  
**Nível:** 1 - Sistema Context Diagram  

---

## 📊 **Visão Geral do Contexto**

O diagrama C4 nível 1 apresenta a **visão contextual** da Plataforma de Processamento na Nuvem, mostrando as **pessoas** (usuários) e **sistemas externos** que interagem com nossa solução principal.

### 🎯 **Objetivo do Sistema**

Processar arquivos de dados (CSV/XML/TXT) e converter para formato PCL otimizado para impressão, oferecendo uma solução escalável na AWS com monitoramento e controle de qualidade.

---

## 👥 **Personas (Usuários do Sistema)**

### 🧑‍💼 **Ana Ribeiro - Operadora de Processamento**

- **Função:** Operadora responsável pelo upload e monitoramento
- **Atividades:** Faz upload de arquivos, acompanha status de processamento, reprocessa quando necessário
- **Interação:** Interface web principal do sistema

### 🖨️ **Carlos Mendes - Responsável pela Impressão**

- **Função:** Técnico responsável pela operação de impressão
- **Atividades:** Baixa arquivos PCL processados e realiza impressão
- **Interação:** Download de arquivos PCL via interface ou API

### 📈 **Marcos Oliveira - Gestor de Produção**

- **Função:** Gerente responsável pelo controle de produção
- **Atividades:** Consulta dashboards, analisa KPIs e gera relatórios gerenciais
- **Interação:** Dashboards e relatórios do sistema

---

## 🔌 **Sistemas Externos**

### 📤 **Sistema de Origem de Arquivos**

- **Descrição:** Sistemas clientes que enviam dados para processamento
- **Formatos:** CSV, XML, TXT
- **Integração:** Portal web ou API REST
- **Volume:** Lotes de até 10.000 registros

### 🖨️ **Spool/Impressoras do Cliente**

- **Descrição:** Sistemas de impressão que consomem arquivos PCL
- **Integração:** Download direto ou consumo via API
- **Formatos:** PCL otimizado para impressão

### 📧 **Serviço de Notificações**

- **Descrição:** Sistema de alertas e comunicações
- **Canais:** E-mail, Webhook, SMS (futuro)
- **Eventos:** Status de processamento, erros, alertas de SLA

### 🔐 **Provedor de Identidade (Opcional)**

- **Descrição:** Sistema de autenticação e autorização externo
- **Protocolos:** SAML, OAuth 2.0, OpenID Connect
- **Status:** Opcional, integração futura

---

## 🎨 **Diagrama C4 Nível 1 - Contexto**

```plantuml
@startuml C4_Context_Diagram
!include https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/master/C4_Context.puml

HIDE_STEREOTYPE()
title Sistema Context Diagram - Plataforma de Processamento na Nuvem

Person(ana, "Ana Ribeiro", "Operadora de Processamento")
Person(carlos, "Carlos Mendes", "Responsavel pela Impressao")  
Person(marcos, "Marcos Oliveira", "Gestor de Producao")

System(core, "Plataforma de Processamento na Nuvem", "Processa arquivos e converte para PCL")

System_Ext(origem, "Sistema de Origem", "Envia dados via Portal/API")
System_Ext(impressao, "Spool/Impressoras", "Consome arquivos PCL")
System_Ext(notific, "Servico de Notificacoes", "Alertas por E-mail/Webhook")
System_Ext(auth, "Provedor de Identidade", "Autenticacao opcional")

Rel(ana, core, "Gerencia processamento")
Rel(carlos, core, "Download PCL")
Rel(marcos, core, "Consulta relatorios")

Rel(origem, core, "Envia dados")
Rel(core, impressao, "Disponibiliza PCL")
Rel(core, notific, "Dispara alertas")
Rel_Back(auth, core, "Autenticacao")

LAYOUT_WITH_LEGEND()
@enduml
```

---

## 📋 **Descrição das Interações**

### 🔄 **Fluxos Principais**

| Origem | Destino | Interação | Protocolo | Frequência |
|--------|---------|-----------|-----------|------------|
| **Sistemas Clientes** | **Sistema Central** | Envio de lotes de dados | HTTPS/API REST | Diária |
| **Sistema Central** | **Spool Impressão** | Entrega de PCL processado | HTTPS/Download | Sob demanda |
| **Sistema Central** | **Notificações** | Alertas e status | Webhook/E-mail | Tempo real |
| **Ana (Operadora)** | **Sistema Central** | Gestão de processamento | HTTPS/Web UI | Contínua |
| **Carlos (Impressão)** | **Sistema Central** | Download de arquivos | HTTPS/Web UI | Diária |
| **Marcos (Gestor)** | **Sistema Central** | Consulta de relatórios | HTTPS/Web UI | Semanal |

### 🔐 **Fluxos de Segurança**

| Componente | Método | Descrição |
|------------|--------|-----------|
| **Autenticação** | Local/Externo | Login via sistema próprio ou provedor externo |
| **Autorização** | RBAC | Controle baseado em papéis por funcionalidade |
| **Comunicação** | TLS 1.3 | Criptografia em todas as comunicações |
| **Dados** | AES-256 | Criptografia de dados em repouso |

---

## 🏷️ **Legenda do Diagrama**

### 🎨 **Códigos de Cores**

- 🔵 **Azul Claro:** Personas/Usuários do sistema
- 🟣 **Roxo:** Sistema principal (nossa solução)
- 🟠 **Laranja:** Sistemas externos/terceiros

### 🔗 **Tipos de Conexão**

- **Linha Sólida:** Integração direta/automática
- **Linha Pontilhada:** Interação manual/usuário

---

## 📊 **Métricas e SLAs do Contexto**

### ⚡ **Performance**

- **Throughput:** 10.000 registros/hora
- **Latência API:** < 200ms (95º percentil)
- **Disponibilidade:** 99.5% (objetivo)

### 📈 **Volume de Dados**

- **Arquivos/dia:** 50-200 arquivos
- **Registros/dia:** 100.000-500.000 registros
- **Tamanho médio:** 5-50MB por arquivo

### 🎯 **SLAs Contextuais**

- **Processamento:** 95% dos arquivos em < 30 minutos
- **Notificação:** Alertas em < 5 minutos
- **Download PCL:** Disponível em < 2 minutos após processamento

---

## 🔮 **Evoluções Futuras (Roadmap)**

### 📅 **Próximas Releases**

1. **Integração SAML/OAuth** - Q1 2026
2. **API v2 com GraphQL** - Q2 2026  
3. **Processamento em lote otimizado** - Q2 2026
4. **Dashboard em tempo real** - Q3 2026

### 🚀 **Visão de Longo Prazo**

- **Multi-tenancy** para múltiplos clientes
- **IA para otimização de PCL**
- **Integração com ERPs populares**
- **Mobile app para monitoramento**
