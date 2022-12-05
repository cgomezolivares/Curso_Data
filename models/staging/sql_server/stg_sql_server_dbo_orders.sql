WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
        --ids
         md5(ORDER_ID) as order_id
        ,TRIM(order_id) as natural_order_id
        ,md5(USER_ID) as user_id
        ,md5(ADDRESS_ID) as address_id
        ,md5(PROMO_ID) as promo_id
        ,md5(TRACKING_ID) as TRACKING_ID
        --strings
        ,trim(SHIPPING_SERVICE) AS servicio_envio
        ,trim(STATUS) as ESTADO_PEDIDO
        --number
        ,cast(ORDER_COST as number(38,2)) AS coste_pedido_usd
        ,cast(SHIPPING_COST as number(38,2)) AS COSTE_ENVIO_usd
        ,cast(ORDER_TOTAL as number(38,2)) AS COSTE_TOTAL_usd
        -- timestamps
        ,CREATED_AT AS fecha_pedido_utc
        ,ESTIMATED_DELIVERY_AT as fecha_envio_estimada_utc
        ,_fivetran_deleted
        ,_fivetran_synced as date_load
    FROM src_orders
    WHERE ESTIMATED_DELIVERY_AT is not null 
    )

SELECT * FROM renamed_casted