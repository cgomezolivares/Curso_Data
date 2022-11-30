WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
         ORDER_ID
        ,SHIPPING_SERVICE AS SERVICIO_ENVIO
        ,PROMO_ID
        ,ORDER_COST AS COSTE_PEDIDO_usd
        ,TRACKING_ID
        ,ESTIMATED_DELIVERY_AT as FECHA_ENVIO_ESTIMADA_utc
        ,USER_ID 
        ,SHIPPING_COST AS COSTE_ENVIO_usd
        ,CREATED_AT AS FECHA_PEDIDO_utc
        ,ORDER_TOTAL AS COSTE_TOTAL_usd
        ,STATUS as ESTADO_PEDIDO
        ,ADDRESS_ID
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_orders
    WHERE ESTIMATED_DELIVERY_AT is not null 
    )

SELECT * FROM renamed_casted