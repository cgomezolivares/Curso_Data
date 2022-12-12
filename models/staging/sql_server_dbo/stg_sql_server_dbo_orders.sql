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
        ,case when promo_id='' then '' else md5(PROMO_ID) end as promo_id
        ,md5(TRACKING_ID) as TRACKING_ID
        --strings
        ,case when SHIPPING_SERVICE = '' then  'unknown' else SHIPPING_SERVICE end as servicio_envio
        ,trim(STATUS) as ESTADO_PEDIDO
        --number
        ,cast(ORDER_COST as number(38,2)) AS coste_pedido_usd
        ,cast(SHIPPING_COST as number(38,2)) AS COSTE_ENVIO_usd
        ,cast(ORDER_TOTAL as number(38,2)) AS COSTE_TOTAL_usd
        -- timestamps
        ,CREATED_AT AS fecha_pedido_utc
        ,case when ESTIMATED_DELIVERY_AT is null then DATEADD(DAY,+7,CREATED_AT) else ESTIMATED_DELIVERY_AT end as fecha_envio_estimada_utc
        ,_fivetran_deleted
        ,_fivetran_synced as date_load
    FROM src_orders
    )

SELECT * FROM renamed_casted