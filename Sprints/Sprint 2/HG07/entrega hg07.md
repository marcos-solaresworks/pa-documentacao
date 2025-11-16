# HG07 – Modelagem dos Componentes (C4 Nível 3)

## 🎯 Objetivo da História
Detalhar os componentes internos dos containers principais da solução — a **API .NET 8**, o **Worker de processamento** e as **Funções Lambda** — evidenciando as responsabilidades internas e os fluxos entre módulos.

---

## ✔️ Critérios de Aceite
- Diagrama de componentes documentado e validado.  
- Integrações entre API, Worker, RabbitMQ, S3 e RDS mapeadas.  
- Componentes principais identificados (controllers, serviços, repositórios, orquestração, parser, gerador PCL).  

---

## 🧱 Componentes da API (.NET 8)

### **Controllers**
- `UploadController`: recebe arquivos e inicia o processamento.
- `StatusController`: consulta status dos lotes.

### **Services**
- `FileValidationService`: valida estrutura e regras do arquivo.
- `RabbitPublisher`: publica mensagens no RabbitMQ.
- `S3Service`: realiza upload/download no S3.

### **Repository**
- `StatusRepository`: comunicação com RDS via EF Core ou Dapper.

### **Cross-Cutting**
- Middleware de autenticação/autorização.  
- Logging e tracing integrados ao CloudWatch.

---

## 🧱 Componentes do Worker (.NET 8)

### **Consumer**
- Consome mensagens da fila principal via AMQP.

### **Orquestrador**
- Gerencia retries, DLQ e backoff.

### **LambdaInvoker**
- Invoca funções AWS Lambda via SDK.

### **StatusUpdater**
- Atualiza logs e estado no RDS.

### **Observabilidade**
- Publica logs no CloudWatch.

---

## 🧱 Componentes da Lambda

### **Parser**
- Lê e interpreta o arquivo (CSV/XML/TXT).

### **Transformação**
- Aplica regras de limpeza, padronização e validação.

### **Gerador PCL**
- Gera layout e arquivo PCL customizado por cliente.

### **Writer S3**
- Salva o PCL no bucket de saída.

---

## 🔗 Fluxos de Comunicação
- API → RabbitMQ: envio de metadados para processamento.  
- Worker → Lambda: processamento assíncrono dos arquivos.  
- Lambda → S3: gravação dos PCLs.  
- Worker → RDS: atualização de status.  
- API → RDS/S3: consultas e downloads.  
- Todos → CloudWatch: logs e métricas.  

---

## 📐 Diagramas C4 – Nível 3 (Componentes)
Arquivos relacionados:
- `c4_level3_api_components.puml`  
- `c4_level3_worker_lambda_components.puml`

Mostram:
- Arquitetura interna da API  
- Arquitetura interna do Worker  
- Pipeline completo da Lambda  

---

## 📌 Observações Técnicas Importantes
- Integração assíncrona baseada em filas RabbitMQ.  
- Todos os módulos seguem boas práticas de separação de responsabilidades.  
- Design orientado à escalabilidade futura e manutenção modular.  
- Limites do Free Tier AWS respeitados.  

---

## 🏁 Status da História
**Concluída ✔️**  
Diagramas C4 Nível 3 criados, documentados e validados.
