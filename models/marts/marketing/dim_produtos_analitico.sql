WITH produtos AS (
    SELECT * FROM {{ ref('stg_produtos') }}
),

vendas AS (
    SELECT * FROM {{ ref('int_vendas') }}
)

SELECT 
    p.product_id,
    p.name_product,
    p.price_product,
    COALESCE(SUM(v.quantity), 0) AS total_vendido,
    COALESCE(SUM(v.total_price), 0) AS total_faturado,
    COALESCE(SUM(v.valor_estornado), 0) AS total_estornado,
    COUNT(CASE WHEN v.valor_estornado > 0 THEN 1 END) AS total_estornos
FROM produtos p
LEFT JOIN vendas v ON p.product_id = v.product_id
GROUP BY p.product_id, p.name_product, p.price_product