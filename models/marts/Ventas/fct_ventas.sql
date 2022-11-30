
{{
  config(
    materialized='table'
  )
}}
WITH dim_user AS (SELECT * FROM {{ ref('dim_clientes') }})
    , dim_order as (SELECT * FROM {{ ref('stg_sql_server_dbo_orders') }} )
    , dim_order_items as (SELECT * FROM {{ ref('stg_sql_server_dbo_order_items') }})
    , dim_product as (SELECT * FROM {{ ref('stg_sql_server_dbo_products') }})
    ,

joined AS (   
  SELECT
        a.order_id
        , b.USER_ID
        , b.ESTADO
        , c.PRODUCT_ID
        , c.CANTIDAD
        , c.CANTIDAD*d.Precio_usd as COSTE_PEDIDO
        , a.created_at as FECHA_PEDIDO

  FROM dim_order a
      inner join dim_user b
      ON a.USER_ID = b.USER_ID
      inner join dim_order_items c
      on a.order_id = c.order_id
      inner join dim_product d
      on c.PRODUCT_ID=d.PRODUCT_ID
    )

SELECT * FROM joined

