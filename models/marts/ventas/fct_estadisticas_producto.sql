{{
  config(
    materialized='incremental',
    unique_key=['order_id','product_id'],
    on_schema_change ='append_new_columns'
  )
}}
WITH dim_user AS (SELECT * FROM {{ ref('dim_users') }})
    , dim_address AS (SELECT * FROM {{ ref('dim_addresses') }})
    , dim_order as (SELECT * FROM {{ ref('stg_sql_server_dbo_orders') }} )
    , dim_order_items as (SELECT * FROM {{ ref('dim_order_items') }})
    , dim_product as (SELECT * FROM {{ ref('dim_products') }})
    ,

joined AS (   
  SELECT
        a.order_id
        , a.USER_ID
        , e.CIUDAD
        , e.ESTADO
        , c.PRODUCT_ID
        , c.cantidad
        , c.CANTIDAD*d.Precio_usd as coste_pedido_usd
        , a.fecha_pedido_utc
        , a.date_load

  FROM dim_order a
      inner join dim_user b
      ON a.USER_ID = b.USER_ID
      inner join dim_order_items c
      on a.order_id = c.order_id
      inner join dim_product d
      on c.PRODUCT_ID=d.PRODUCT_ID
      inner join dim_address e
      on b.address_ID=e.address_ID

)

SELECT * FROM joined

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  having date_load >= (select max(date_load) from {{ this }})

{% endif %}