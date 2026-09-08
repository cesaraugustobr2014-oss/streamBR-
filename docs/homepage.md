{% docs __overview__ %}

# Bem-vindo ao Data Warehouse da StreamBR 📺

## 📌 Sobre este projeto
Este projeto utiliza o **dbt (Data Build Tool)** para transformar e modelar os dados da StreamBR, uma plataforma fictícia de streaming, organizando-os em **camadas estruturadas** para análise de negócios.

## 🔄 Estrutura de Transformação
1️⃣ **Staging** → Extração e padronização dos dados brutos.  
2️⃣ **Intermediate** → Modelos consolidados para facilitar agregações.  
3️⃣ **Marts** → Modelos finais otimizados para BI e análise.

## 📊 Modelos Principais
- `fct_vendas` → Junta as vendas de planos com os estornos e calcula a receita líquida.  
- `dim_clientes_analitico` → Consolida os assinantes e suas métricas de consumo.  
- `dim_produtos_analitico` → Agrega os planos, meses vendidos e faturamento.

## 🚀 Como Executar
- `dbt seed` → Executa os seeds (dados estáticos)
- `dbt run` → Executa todos os modelos
- `dbt test`  → Testa a integridade dos dados
- `dbt docs generate`  → Gera a documentação
- `dbt docs serve`  → Serve a documentação interativa
{% enddocs %}
