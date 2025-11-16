# HG06 – Modelagem dos Containers (C4 Nível 2)

## 🎯 Objetivo da História
Modelar os principais containers da solução da Gráfica Ltda, representando como os módulos do sistema serão implantados na AWS e como se comunicam entre si.  
Este nível da arquitetura descreve a visão macro dos serviços (API, Worker, RabbitMQ, S3, RDS e Frontend), suas responsabilidades e protocolos de integração.

---

## ✔️ Critérios de Aceite
- Diagrama de containers documentado e validado.  
- Interfaces de comunicação e protocolos definidos.  
- Todos os serviços AWS representados no modelo arquitetural.  
- Identificação das integrações externas (Vercel, Notificações, Autenticação).  

---

## 🧱 Containers da Solução

### **Frontend (Vercel)**
- Exibe dashboards e relatórios.
- Comunicação via HTTPS com a API.

### **API (.NET 8 em Docker)**
- Recebe uploads, inicia o fluxo de processamento.
- Publica mensagens no RabbitMQ.
- Consulta dados no RDS.
- Armazena arquivos no S3.

### **Worker (.NET 8 em Docker)**
- Consome mensagens do RabbitMQ.
- Invoca funções AWS Lambda.
- Atualiza status no RDS.

### **RabbitMQ (Docker)**
- Realiza a mensageria assíncrona.
- Possui DLQ e política de retry/backoff.

### **AWS Lambda**
- Responsável pelo processamento dos arquivos e geração do PCL.

### **Amazon S3**
- Armazena arquivos de entrada e saída.

### **Amazon RDS (PostgreSQL)**
- Guarda metadados, logs e histórico de execução.

### **CloudWatch**
- Centraliza logs e métricas.

---

## 🔗 Protocolos e Comunicação
- **HTTPS**: Frontend → API, API → S3, API → RDS.  
- **AMQP**: API → RabbitMQ → Worker.  
- **AWS SDK**: Worker → Lambda, Lambda → S3.  
- **SQL**: API/Worker → RDS.  

---

## 📐 Diagrama C4 – Nível 2 (Containers)
Arquivo relacionado: `c4_level2_containers.puml`  
Representa:
- VPC AWS  
- Subnet pública (EC2 + Containers)  
- Subnet privada (RDS, Lambda, S3)  
- Frontend na Vercel  
- Mensageria, armazenamento e servidor de aplicações

---

## 📌 Observações Técnicas Importantes
- Containers executados manualmente via **Portainer CE** (sem deploy automatizado).  
- Uso do **Free Tier AWS** para EC2 e RDS.  
- Arquitetura modular para facilitar escalabilidade futura.  
- Logs e monitoramento consolidados em **CloudWatch**.

---

## 🏁 Status da História
**Concluída ✔️**  
Diagrama C4 Nível 2 documentado e validado.
