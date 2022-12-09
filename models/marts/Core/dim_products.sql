
{{
  config(
    materialized='incremental',
    unique_key=('product_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH dim_products AS (SELECT * FROM {{ ref('stg_sql_server_dbo_products') }})
,

gold_products AS (   
   SELECT
         product_id
        ,natural_product_id
        ,Precio_usd
        ,nombre_producto
        ,num_inventario
        ,date_load
    FROM dim_products

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}
)

SELECT * FROM gold_products