# HG02 – Definir a Infraestrutura Cloud AWS (HG02)

## Descrição
Selecionar os serviços AWS que serão utilizados na solução (EC2, RDS, S3) e definir o **modelo de implantação inicial (MVP)** para a Gráfica Ltda.

---

## Objetivos
1. Mapear os serviços AWS utilizados e suas responsabilidades.
2. Definir o que roda em EC2 (containers) e o que será serverless (Lambda).
3. Descrever a topologia inicial (rede, subnets, SGs) e segurança.
4. Estimar custos mensais do MVP.

---

## Serviços AWS Selecionados e Justificativas

| Camada | Serviço | Descrição Técnica | Justificativa |
|--------|---------|-------------------|---------------|
| Cálculo/Execução | **EC2 (t3.micro)** | Hospeda **API .NET 8**, **Worker** e **RabbitMQ** em containers; gerido via **Portainer CE**. | **Free Tier elegível** (750h/mês gratuitas), melhor performance que t2.micro, compatível com Docker. |
| Mensageria | **RabbitMQ (em EC2)** | Broker de filas para orquestração assíncrona entre API, Worker e Lambdas. | Desacoplamento, confiabilidade e retry/DLQ. |
| Processamento | **AWS Lambda** | Funções para transformação/validação e **geração de PCL** sob demanda. | **Free Tier**: 1M execuções/mês gratuitas, escalabilidade automática. |
| Banco de dados | **RDS PostgreSQL (t3.micro)** | Base persistente para **metadados de processamento** e **monitoramento**. | **Free Tier elegível** (750h/mês), gerenciamento automático, backups. |
| Arquivos | **Amazon S3** | Buckets versionados para entrada e PCL gerado. | Alta durabilidade e custo baixo. |
| Rede | **VPC + Subnets + SGs** | Subnet pública (EC2/Portainer/RabbitMQ) e privada (RDS/Lambda/S3). | Isolamento e segurança. |
| Observabilidade | **CloudWatch** | Logs, métricas e alarmes. | Operação e suporte. |
| Gerenciamento | **Portainer CE** | Gestão manual de stacks/containers. | Agilidade operacional (sem GitOps no CE). |
| Frontend | **Vercel** | Painel web (Next.js) para acompanhamento. | Desacoplado e sem custo no MVP. |

---

## 📊 **Estimativa de Custos MVP (us-east-1 - Norte da Virgínia)**

| Serviço | Configuração | Custo Mensal (USD) |
|---------|-------------|-------------------|
| **EC2** | t3.micro (750h Free Tier) | $0,00 |
| **RDS** | t3.micro PostgreSQL (750h Free Tier) | $0,00 |
| **S3** | Standard (5GB Free Tier) | $0,00 |
| **Lambda** | 1M execuções/mês (Free Tier) | $0,00 |
| **CloudWatch** | Logs básicos (5GB Free Tier) | $0,00 |
| **VPC** | Sem NAT Gateway (apenas Internet Gateway) | $0,00 |
| **Data Transfer** | 1GB/mês de saída (Free Tier) | $0,00 |
| **TOTAL MVP** | - | **$0,00/mês** |

> **Configuração Free Tier - região us-east-1 (Norte da Virgínia) - Novembro 2025**

### ⚠️ **Limitações do Free Tier para MVP:**

- **EC2 t3.micro**: 750 horas/mês (1 instância 24/7)
- **RDS t3.micro**: 750 horas/mês + 20GB storage
- **S3**: 5GB Standard storage + 20.000 GET + 2.000 PUT
- **Lambda**: 1M execuções + 400.000 GB-segundos
- **CloudWatch**: 10 métricas customizadas + 5GB logs
- **Data Transfer**: 1GB/mês de saída

### 🆓 **Estratégia Free Tier para MVP:**

- **Região us-east-1**: Menor custo e maior disponibilidade de Free Tier
- **t3.micro**: Instância elegível para 12 meses gratuitos com melhor performance
- **Arquitetura simplificada**: Sem NAT Gateway, ALB ou serviços premium
- **Monitoramento básico**: CloudWatch gratuito para métricas essenciais
- **Armazenamento mínimo**: 5GB S3 + 20GB RDS suficientes para testes

### 📈 **Custos Após Free Tier (13º mês):**

| Serviço | Configuração | Custo Mensal (USD) |
|---------|-------------|-------------------|
| **EC2** | t3.micro (730h) | $8,76 |
| **RDS** | t3.micro PostgreSQL (730h + 20GB) | $15,30 |
| **S3** | Standard (20GB) | $0,46 |
| **Lambda** | 1M execuções/mês | $0,20 |
| **CloudWatch** | Logs básicos (5GB) | $2,50 |
| **Data Transfer** | 5GB/mês de saída | $0,45 |
| **TOTAL pós Free Tier** | - | **$27,67/mês** |

> Custo estimado após o período de 12 meses do Free Tier.

---

## Topologia Inicial (texto)

- **VPC 10.0.0.0/16**  
  - **Subnet Pública:** EC2 (API, Worker, RabbitMQ, Portainer)  
  - **Subnet Privada:** RDS, Lambdas, S3 (endpoints)  
  - **Security Groups:** web (HTTPS), broker, banco; tráfego mínimo necessário

```text
Internet Gateway → Public Subnet (10.0.1.0/24) → EC2 t3.micro
                                                → RDS t3.micro (Public para Free Tier)
```

### 🔧 **Simplificações para Free Tier:**

- **RDS em subnet pública**: Evita NAT Gateway (custo adicional)
- **Security Group restritivo**: Acesso RDS apenas do EC2
- **Sem Multi-AZ**: Configuração single-AZ para Free Tier
- **Backup básico**: 7 dias automático incluído no Free Tier

## 🔐 Segurança e Conformidade

- **TLS 1.2+** em todo tráfego; **S3/RDS criptografados** (AWS managed keys)
- **IAM roles/policies** granulares por serviço; **MFA** em contas de administração
- **CloudTrail básico** para auditoria (Free Tier: 90 dias)
- **Security Groups** restritivos: RDS apenas do EC2, HTTPS público
- **Backup automático RDS** (7 dias); **versionamento S3** ativo
- **Secrets** em variáveis de ambiente (AWS Secrets Manager opcional)

### ⚠️ **Considerações de Localização de Dados:**

- **Dados processados em us-east-1** (Norte da Virgínia, EUA)
- **Não conformidade com LGPD** devido ao processamento fora do Brasil
- **Adequado apenas para MVP/testes** sem dados pessoais sensíveis
- **Para produção**: considerar migração para sa-east-1 (São Paulo)

### **IAM Roles (Least Privilege):**

- `APIRole` (S3 read/write, RDS access)
- `WorkerRole` (RabbitMQ access, Lambda Invoke)
- `LambdaExecutionRole` (S3, CloudWatch)

## 📊 Critérios de Aceite

- **Serviços AWS Free Tier** definidos e documentados
- **Custo $0/mês** durante 12 meses (Free Tier)
- **Segurança básica** implementada (IAM, Security Groups, TLS)
- **Topologia simplificada** adequada para MVP
- **Backup e monitoramento** básicos configurados
- **Limitações de LGPD** documentadas e aceitas para MVP

## ✅ Entregáveis

1. Documento de **Infraestrutura Cloud AWS Free Tier** (este `.md`)
2. **Topologia de rede** simplificada (texto/ASCII)
3. **Planilha de custos** Free Tier + pós-Free Tier
4. **Checklist de segurança** básica implementada
5. **Aviso de conformidade** sobre localização de dados

---

> **Observação:** o **C4 Model (Nível 2)** será entregue em história própria (HG05, HG06 e HG07 que correspondem à criação de C4 Model de nível 1, 2 e 3), conforme backlog.
