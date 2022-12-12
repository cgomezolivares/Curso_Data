{{
  config(
    materialized='incremental',
    unique_key=('product_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH dim_order_items as (SELECT * FROM {{ ref('stg_sql_server_dbo_order_items') }} )
    , dim_budget as (SELECT * FROM {{ ref('stg_google_sheets_budget') }} )
    , dim_product as (SELECT * FROM {{ ref('stg_sql_server_dbo_products') }} )
    ,

productos_vendidos as (
    SELECT
        PRODUCT_ID
        ,sum(CANTIDAD) as CANTIDAD_PRODUCTOS_PEDIDOS
    FROM dim_order_items
    group by PRODUCT_ID
)
--select * from productos_vendidos
,
productos_budget as ( 
    SELECT
        PRODUCT_ID
        ,sum(quantity) as CANTIDAD_BUDGET
    FROM dim_budget
    group by PRODUCT_ID
)
--select * from productos_vendidos
,
stock AS (   
    SELECT
        A.PRODUCT_ID
        ,CANTIDAD_PRODUCTOS_PEDIDOS 
        ,B.CANTIDAD_BUDGET
        ,(A.CANTIDAD_PRODUCTOS_PEDIDOS-B.CANTIDAD_BUDGET) as Diferencia
        ,c.INVENTARIO
        ,(c.INVENTARIO-B.CANTIDAD_BUDGET) as stock_esperado
        ,(c.INVENTARIO-a.CANTIDAD_PRODUCTOS_PEDIDOS) as stock_real
        ,case when stock_real < 0  then 'Reponer_Stock' else '' end as aviso_stock
        ,c.date_load
        

    FROM  productos_vendidos a 
    inner join productos_budget b
    on A.PRODUCT_ID=B.PRODUCT_ID
    inner join dim_product c 
    on a.product_id=c.product_id

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}
    )

SELECT * FROM stock order by 1 asc