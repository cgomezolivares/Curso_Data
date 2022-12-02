{{
  config(
    materialized='table'
  )
}}
WITH dim_products AS (SELECT * FROM {{ ref('stg_sql_server_dbo_products') }})
,

gold_products AS (   
   SELECT
         product_id
        ,Precio_usd
        ,nombre_producto
        ,num_inventario
        ,_fivetran_deleted 
        ,date_load
    FROM dim_products 
    )

SELECT * FROM gold_products