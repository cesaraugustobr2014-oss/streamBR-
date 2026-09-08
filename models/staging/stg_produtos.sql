WITH source AS (
    SELECT *
    FROM {{ source('landing', 'produtos') }}
),

renamed AS (
    SELECT
    cast(product_id as int) as product_id,
    name as name_product,
    price as price_product
    FROM source
)

SELECT * FROM renamed