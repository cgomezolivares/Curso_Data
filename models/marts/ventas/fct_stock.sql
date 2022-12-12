{{
  config(
    materialized='incremental',
    unique_key=('product_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH stock AS (SELECT * FROM {{ ref('int_budget') }})
,

gold_stock AS (   
    SELECT
        product_id
        ,cantidad_productos_pedidos
        ,cantidad_budget
        ,Diferencia
        ,inventario
        ,stock_esperado
        ,stock_real
        ,aviso_stock
        ,date_load
    FROM stock
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}

)

SELECT * FROM gold_stock order by 1 asc