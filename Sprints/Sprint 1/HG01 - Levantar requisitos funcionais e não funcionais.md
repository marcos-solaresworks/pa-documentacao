# Especificação de Requisitos - Sistema de Processamento de Dados

## 1. Requisitos Funcionais (RF)

### 1.1 Ingestão e Validação de Dados

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-001** | Upload de arquivos pelo Portal (CSV, XML, TXT) e via API | **Obrigatório** | Enviar arquivo até limite configurável; receber confirmação; arquivo armazenado no S3 com metadados (cliente, lote, hash). |
| **RF-002** | Validação de integridade (hash/checksum) e tamanho | **Obrigatório** | Arquivos inválidos são rejeitados com motivo; logs no RDS. |
| **RF-003** | Validação de conteúdo por cliente (schema/regra) | **Obrigatório** | Regras por cliente parametrizadas; lote rejeitado/aceito com relatório de erros. |

### 1.2 Orquestração e Processamento

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-004** | Criação de tarefa na fila RabbitMQ para cada arquivo/lote | **Obrigatório** | Mensagem publicada com idempotency-key; persistência do status no RDS. |
| **RF-005** | Worker (EC2) consome filas e invoca Lambdas | **Obrigatório** | Worker lê mensagem, invoca Lambda adequada, aguarda resultado, confirma (ACK) ou reencaminha (NACK/DLQ). |
| **RF-006** | Retry com backoff e DLQ | **Obrigatório** | Até n tentativas configuráveis; após esgotar, mensagem vai para DLQ com causa. |
| **RF-007** | Processamento em Lambdas (parse → transformação → geração PCL) | **Obrigatório** | Fluxo executa etapas e registra tempos/etapas no RDS/CloudWatch. |

### 1.3 Geração e Armazenamento de Saída

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-008** | Geração de PCL com template por cliente | **Obrigatório** | Template versionado; saída PCL validada e armazenada no S3. |
| **RF-009** | Armazenamento em S3 com versionamento | **Obrigatório** | PCL e artefatos salvos com chave canônica (cliente/ano/mês/dia/lote/id). |
| **RF-010** | Entrega/Download do PCL | **Obrigatório** | Link assinado (tempo configurável) disponível no Portal e via API. |

### 1.4 Monitoramento e Controle

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-011** | Painel de acompanhamento (status por lote/arquivo) | **Obrigatório** | Tabela/visão com estados: recebido, em fila, em processamento, concluído, erro, reprocessado. |
| **RF-012** | Alertas (falha, atraso, DLQ, SLA) | **Importante** | Envio por e-mail e/ou webhook; parametrização por cliente e tipo de evento. |
| **RF-013** | Reprocessamento manual de item/lote | **Importante** | Operador pode reenfileirar item com motivo e rastreabilidade. |

### 1.5 Gestão de Usuários e Permissões

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-014** | Cadastro/gestão de clientes e regras de negócio | **Obrigatório** | CRUD de clientes, templates, mapeamentos, limites e SLA por cliente. |
| **RF-015** | Perfis e permissões (Operadora, Impressão, Gestor, Admin) | **Obrigatório** | RBAC: cada perfil enxerga/atua apenas no escopo permitido. |
| **RF-016** | Autenticação (Portal) e autorização (API) | **Obrigatório** | Login com MFA opcional; API com JWT; escopos por perfil. |

### 1.6 Auditoria e Logs

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-017** | Auditoria de ações e eventos | **Obrigatório** | Registrar: quem/quando/oquê; consultas com filtro por período/cliente. |
| **RF-018** | Logs estruturados e tracing | **Obrigatório** | Correlação por correlationId (do upload até a Lambda). |

### 1.7 Relatórios e Analytics

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-019** | Relatórios operacionais (produtividade, falhas, tempo médio) | **Importante** | Exportação CSV/JSON; filtros por período/cliente/status. |
| **RF-020** | KPIs/Dashboards (SLA, taxa de erro, tempo de fila, custo estimado) | **Importante** | Widgets com metas; fonte RDS/CloudWatch/S3 Inventory. |

### 1.8 Configuração e Administração

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-021** | Configuração de limites (tamanho de arquivo, concorrência, TTL link) | **Importante** | Valores por cliente e padrão global. |
| **RF-022** | Webhooks/Callbacks para clientes (opcional) | **Desejável** | Disparo de eventos "processado/erro" com assinatura HMAC. |
| **RF-023** | Sanitização e anonimização quando aplicável (LGPD) | **Obrigatório** | Campos sensíveis mascarados nos logs e exportações. |

### 1.9 Infraestrutura e Operações

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-024** | Health-checks (API, Worker, Broker, RDS) | **Obrigatório** | Endpoint /health com status e dependências. |
| **RF-025** | Provisionamento/gestão de containers via Portainer CE | **Importante** | Stacks Docker versionadas; rede/volumes geridos via Portainer. |
| **RF-026** | Backup e restauração (RDS/S3 config) | **Obrigatório** | Políticas definidas; teste de restauração documentado. |

### 1.10 Catálogos e Versionamento

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-027** | Catálogo de templates PCL com versionamento e roll-back | **Importante** | Histórico, comparador de versões e ativação por cliente. |
| **RF-028** | Catálogo de esquemas de entrada (CSV/XML) | **Importante** | Validações por versão e cliente. |

### 1.11 Integrações Futuras

| ID | Requisito | Prioridade | Critérios de Aceite (DoD) |
|----|-----------|------------|---------------------------|
| **RF-029** | Integração de impressão (opcional – fase 2) | **Desejável** | Disparo para spool remoto/cliente quando habilitado. |

> **Observação**: Nos RFs com limites (tamanho, tentativas, TTL), trate como parametrizáveis para ajustar por cliente/SLA.

---

## 2. Requisitos Não Funcionais (RNF)

### 2.1 Performance e Escalabilidade

| ID | Categoria | Requisito | Critérios/Meta |
|----|-----------|-----------|----------------|
| **RNF-001** | **Desempenho** | Tempo de ingestão (upload → fila) | ≤ 10s para arquivos padrão (rede normal), medido P50; parametrizável. |
| **RNF-002** | **Desempenho** | Tempo médio de processamento por arquivo | Reduzir em 30% vs. baseline legado; acompanhar P50/P95. |
| **RNF-003** | **Escalabilidade** | Concorrência elástica via Lambdas | Parâmetros de concorrência ajustáveis; Worker sem backpressure. |
| **RNF-019** | **Performance fila** | Tempo de espera em fila | Alvo inicial P95 ≤ 5 min (ajustável por demanda). |

### 2.2 Disponibilidade e Confiabilidade

| ID | Categoria | Requisito | Critérios/Meta |
|----|-----------|-----------|----------------|
| **RNF-004** | **Disponibilidade** | Portal + API | ≥ 99,5% (MVP) com health-check e restart policy. |
| **RNF-005** | **Confiabilidade** | Entrega pelo menos uma vez (at-least-once) | Idempotência por idempotencyKey em Worker/Lambdas. |
| **RNF-006** | **Resiliência** | Retry/backoff + DLQ | Backoff exponencial; inspeção e reprocesso a partir da DLQ. |
| **RNF-014** | **Confiabilidade dados** | Consistência de metadados | Cada arquivo com cliente, lote, hash, schemaVersion, templateVersion. |

### 2.3 Segurança

| ID | Categoria | Requisito | Critérios/Meta |
|----|-----------|-----------|----------------|
| **RNF-007** | **Segurança** | Trânsito TLS 1.2+; at-rest encryption | HTTPS em todo o tráfego; S3/RDS com criptografia (KMS/gerenciado). |
| **RNF-008** | **Segurança** | IAM de menor privilégio | Roles separados: API, Worker, Lambdas; acesso mínimo a S3/RDS. |
| **RNF-009** | **LGPD** | Bases legais + retenção | Política de retenção/expurgo; mascaramento em logs; consentimento onde aplicável. |
| **RNF-018** | **Segurança app** | Hardening | Rate-limit na API; validação de payload; proteção a injeção/XXE. |

### 2.4 Observabilidade e Monitoramento

| ID | Categoria | Requisito | Critérios/Meta |
|----|-----------|-----------|----------------|
| **RNF-010** | **Observabilidade** | Logs, métricas, tracing | Correlação fim-a-fim; dashboards (fila, latência, erro, custo). |
| **RNF-020** | **Suporte** | Trilha de auditoria | 100% das ações críticas auditadas e consultáveis por período. |

### 2.5 Manutenibilidade e Portabilidade

| ID | Categoria | Requisito | Critérios/Meta |
|----|-----------|-----------|----------------|
| **RNF-011** | **Manutenibilidade** | Codebase | Padrões de clean architecture; testes unitários e de integração. |
| **RNF-012** | **Portabilidade** | Containers Docker | Dev/QA/Prod com Compose/Stacks; gestão via Portainer CE. |
| **RNF-013** | **Compatibilidade** | Front Vercel + API | CORS configurado por origem/ambiente; OpenAPI 3. |

### 2.6 Backup e Custos

| ID | Categoria | Requisito | Critérios/Meta |
|----|-----------|-----------|----------------|
| **RNF-015** | **Backup/DR** | RDS snapshots + S3 Versioning | RPO ≤ 24h (MVP) e procedimento de restauração testado. |
| **RNF-016** | **Custos** | FinOps básico | Budget/alarme por serviço; relatório mensal por cliente. |

### 2.7 Usabilidade

| ID | Categoria | Requisito | Critérios/Meta |
|----|-----------|-----------|----------------|
| **RNF-017** | **Usabilidade** | Portal acessível | Layout responsivo; feedback de progresso e erros claros. |

---

## 3. Controle de Acesso (RBAC)

### 3.1 Papéis e Escopo de Acesso

| Papel | Usuário | Permissões |
|-------|---------|------------|
| **Operadora** | Ana | • Upload de arquivos<br>• Consulta de status<br>• Reprocessamento<br>• Visualização de erros |
| **Impressão** | Carlos | • Listar e baixar PCL<br>• Visualizar status de lotes prontos |
| **Gestor** | Marcos | • Dashboards e relatórios<br>• Gestão de DLQ<br>• Configuração de SLA |
| **Admin** | - | • Gestão de clientes<br>• Gestão de templates e esquemas<br>• Gestão de usuários e perfis |

---

## 4. KPIs e Métricas

### 4.1 KPIs Propostos para Dashboard

1. **Performance**
   - Tempo médio de processamento por arquivo/lote (P50/P95)
   - Tempo médio na fila (RabbitMQ)

2. **Qualidade**
   - Taxa de falhas por etapa (validação, Lambda, upload S3)
   - Reprocessos por causa/cliente

3. **Custos**
   - Custo estimado por cliente/arquivo (Lambdas + S3)

4. **Disponibilidade**
   - Disponibilidade API/Portal

---

## 5. Observações de Implementação (MVP)

### 5.1 Configurações Técnicas

- **Portainer CE**: Gestão manual de stacks (sem GitOps automático)
- **Idempotência**: Chave derivada de (cliente + hash do arquivo + timestamp lógico)
- **Templates**: PCL e schemas versionados em repositório e referenciados na execução
- **Segurança**: Segregar roles IAM por componente; nunca expor chaves no código

### 5.2 Priorização

- **Obrigatório**: Funcionalidades críticas para MVP
- **Importante**: Funcionalidades importantes para operação completa
- **Desejável**: Funcionalidades desejáveis para fases futuras
