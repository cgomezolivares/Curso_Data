{{
  config(
    materialized='table'
  )
}}
WITH dim_order AS (SELECT * FROM {{ ref('stg_sql_server_dbo_orders') }})
    , dim_promo as (SELECT * FROM {{ ref('stg_sql_server_dbo_promos') }} )
    ,


joined1 AS (   
    SELECT
        a.order_id 
        , a.user_id 
        , a.address_id
        , a.coste_pedido_usd
        , a.coste_envio_usd
        , b.descuento_usd 
        , a.coste_total_usd
        , a.fecha_pedido_utc
        , a.fecha_envio_estimada_utc
        , a.estado_pedido
        , a.servicio_envio
				, DATEDIFF(day, a.fecha_pedido_utc, a.fecha_envio_estimada_utc) AS dias_envio
        , a.tracking_id
        , a.date_load

    FROM dim_order a
    left join dim_promo B
    ON A.PROMO_ID = B.PROMO_ID
    )
,

joined2 AS (
    SELECT  
        order_id 
        , user_id 
        , address_id
        , coste_pedido_usd
        , coste_envio_usd
        , CASE
          WHEN descuento_usd IS NULL THEN '0'
          ELSE descuento_usd
          END AS descuento_promo_usd
        , coste_total_usd
        , fecha_pedido_utc
        , fecha_envio_estimada_utc
        , estado_pedido
        , servicio_envio
				, dias_envio
        , tracking_id
        , date_load

    FROM joined1
    )

SELECT * FROM joined2