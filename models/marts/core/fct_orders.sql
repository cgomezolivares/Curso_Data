{{
  config(
    materialized='incremental',
    unique_key=('order_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH dim_order AS (SELECT * FROM {{ ref('stg_sql_server_dbo_orders') }})
,


gold_orders AS (   
    SELECT
        order_id 
        , natural_order_id
        , user_id 
        , address_id
        , coste_pedido_usd
        , coste_envio_usd
        , promo_id
        , coste_total_usd
        , fecha_pedido_utc
        , fecha_envio_estimada_utc
        , estado_pedido
        , servicio_envio
		    , DATEDIFF(day, fecha_pedido_utc, fecha_envio_estimada_utc) AS dias_envio
        , tracking_id
        , date_load

    FROM dim_order 

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load > (select max(date_load) from {{ this }})

{% endif %}

)

SELECT * FROM gold_orders