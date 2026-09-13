# StreamBR - Analytics Engineering com dbt & PostgreSQL

Projeto de Analytics Engineering e Modelagem Dimensional para a plataforma de streaming **StreamBR**, utilizando **dbt (data build tool)**, **PostgreSQL (AWS RDS)** e **dbt Cloud**.

O projeto cobre o ciclo completo de engenharia analítica: ingestão de dados brutos relacionais, saneamento e tipagem em camada bronze, enriquecimento intermediário em camada silver, e criação de modelos analíticos finais (Star Schema) prontos para consumo por áreas de negócio (Finanças e Marketing), com testes automatizados e governança de dados.

---

## Arquitetura de Dados (Medallion / dbt Layers)

```
[ PostgreSQL / Landing ]
  clientes, produtos, vendas, estorno (seed)
             │
             ▼
[ Camada Staging (Bronze) ] ── (Materialização: View)
  stg_clientes, stg_produtos, stg_vendas, stg_estorno
  • Validação e conversão estrita de tipos
  • Padronização em snake_case e renomeação explícita de colunas
  • Nenhuma regra de negócio aplicada
             │
             ▼
[ Camada Intermediate (Silver) ] ── (Materialização: View)
  int_vendas, int_clientes, int_produtos, int_estorno
  • Joins e tratamento de estornos de cobrança
  • Métricas intermediárias e consolidações pré-agregadas
             │
             ▼
[ Camada Marts (Gold) ] ── (Materialização: Table)
  ├── Finance:   fct_vendas (Fato detalhada com receita líquida e motivo de reembolso)
  └── Marketing: dim_clientes_analitico, dim_produtos_analitico
      • Modelos dimensionais prontos para BI, Self-service e Reporting
```

---

## Modelagem e Regras de Negócio

### 1. Modelo de Negócio da Plataforma
- **Assinaturas e Planos:** Assinantes contratam planos pré-pagos (Básico, Padrão, Premium, Família, Esportes, etc.).
- **Vendas (`vendas`):** Cada registro representa uma assinatura ou renovação. A coluna `quantity` indica a quantidade de meses contratados, e `total_price` representa o valor final faturado após possíveis cupons e descontos sazonais.
- **Estornos (`estorno`):** Ingeridos via `seed` para simular devoluções de cobrança (cobrança duplicada, insatisfação, cancelamento ou serviço indisponível).

### 2. Principais Modelos de Consumo

| Modelo | Tipo | Granularidade | Finalidade |
|---|---|---|---|
| `fct_vendas` | Fato | 1 linha por transação de compra | Análise de faturamento bruto, estornos e cálculo de **receita líquida** (`total_price - valor_estornado`). |
| `dim_clientes_analitico` | Dimensão | 1 linha por cliente | Indicadores de Customer Lifetime Value (LTV), total de compras, diversidade de planos e estornos por cliente. |
| `dim_produtos_analitico` | Dimensão | 1 linha por plano | Métricas de conversão de planos, total de meses vendidos, faturamento acumulado e taxa de estorno por produto. |

---

## Qualidade e Testes de Dados

Os modelos contam com testes declarativos configurados nos arquivos `schema.yml`:
- **Unicidade e Nulos:** Chaves primárias testadas com `unique` e `not_null` em todas as camadas (`purchase_id`, `customer_id`, `product_id`).
- **Integridade Referencial:** Testes de `relationships` assegurando que vendas apontem para clientes e produtos válidos.
- **Valores Permitidos:** Teste de `accepted_values` nos motivos de estorno (`refund_reason`).

---

## Estrutura do Repositório

```
├── dbt_project.yml          # Configuração global, tags, schemas e materializações
├── models/
│   ├── source.yml           # Declaração das fontes brutas (landing)
│   ├── staging/             # Camada Bronze (stg_*)
│   │   ├── schema.yml
│   │   ├── stg_clientes.sql
│   │   ├── stg_produtos.sql
│   │   ├── stg_vendas.sql
│   │   └── stg_estorno.sql
│   ├── intermediate/        # Camada Silver (int_*)
│   │   ├── schema.yml
│   │   ├── int_vendas.sql
│   │   ├── int_clientes.sql
│   │   └── int_produtos.sql
│   └── marts/               # Camada Gold (fct_* / dim_*)
│       ├── finance/
│       │   ├── schema.yml
│       │   └── fct_vendas.sql
│       └── marketing/
│           ├── schema.yml
│           ├── dim_clientes_analitico.sql
│           └── dim_produtos_analitico.sql
├── seeds/
│   └── estorno.csv          # Base estática de estornos
├── scripts-sql/             # DDL e carga inicial do banco relacional
│   ├── clientes.sql
│   ├── produtos.sql
│   └── vendas.sql
└── macros/                  # Custom macros de nomenclatura de schemas
```

---

## Como Executar o Projeto

### Pré-requisitos
- Python 3.9+
- PostgreSQL configurado (local ou cloud)
- Pacote `dbt-postgres` (v1.9+)

### 1. Instalação das Dependências
```bash
pip install dbt-postgres
```

### 2. Configurar o Perfil de Conexão (`profiles.yml`)
Certifique-se de configurar o profile `streambr` em `~/.dbt/profiles.yml`:
```yaml
streambr:
  target: dev
  outputs:
    dev:
      type: postgres
      host: <SEU_HOST>
      user: <SEU_USUARIO>
      password: <SUA_SENHA>
      port: 5432
      dbname: streambr
      schema: public
      threads: 4
```

### 3. Execução dos Modelos e Testes
```bash
# Testar conectividade com o banco
dbt debug

# Carregar seeds (tabela de estornos)
dbt seed

# Compilar e executar todos os modelos
dbt run

# Executar testes de qualidade
dbt test

# Gerar e visualizar a documentação interativa
dbt docs generate
dbt docs serve
```

---

## Autor

Desenvolvido por **Cesar Augusto**.

[![LinkedIn](https://img.shields.io/badge/LinkedIn-Perfil-blue?style=flat&logo=linkedin)](https://www.linkedin.com/in/cesaraugustooliveirarodrigues/)
[![GitHub](https://img.shields.io/badge/GitHub-Portfólio-darkgreen?style=flat&logo=github)](https://github.com/cesaraugustobr2014-oss)

---

## Licença

Distribuído sob a licença MIT.
