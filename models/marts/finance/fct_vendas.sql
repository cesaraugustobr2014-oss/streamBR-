WITH vendas AS (
    SELECT * FROM {{ ref('int_vendas') }}
),

clientes AS (
    SELECT * FROM {{ ref('int_clientes') }}
),

produtos AS (
    SELECT * FROM {{ ref('int_produtos') }}
)

SELECT 
    v.purchase_id,
    v.customer_id,
    c.customer_name,
    c.customer_email,
    v.product_id,
    p.name_product,
    v.purchase_date,
    v.quantity,
    v.total_price,
    v.payment_method,
    v.valor_estornado,
    v.refund_reason,
    (v.total_price - v.valor_estornado) AS receita_liquida
FROM vendas v
LEFT JOIN clientes c ON v.customer_id = c.customer_id
LEFT JOIN produtos p ON v.product_id = p.product_id