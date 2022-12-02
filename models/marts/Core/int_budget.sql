{{
  config(
    materialized='table'
  )
}}
WITH dim_order_items as (SELECT * FROM {{ ref('int_order_items') }} )
    , dim_budget as (SELECT * FROM {{ ref('stg_google_sheets_budget') }} )
    ,

ventas as (
    SELECT
        PRODUCT_ID
        , sum(CANTIDAD) as CANTIDAD_PRODUCTOS_PEDIDOS
    FROM dim_order_items
    group by PRODUCT_ID
)
,
stock AS (   
    SELECT
        A.PRODUCT_ID
        ,a.CANTIDAD_PRODUCTOS_PEDIDOS
        ,B.QUANTITY AS CANTIDAD_BUDGET
        ,(B.QUANTITY - A.CANTIDAD_PRODUCTOS_PEDIDOS) AS stock

    FROM  ventas a 
    join dim_budget b
    on A.PRODUCT_ID=B.PRODUCT_ID
    )

SELECT * FROM stock