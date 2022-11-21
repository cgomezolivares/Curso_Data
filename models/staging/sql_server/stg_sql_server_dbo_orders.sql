WITH src_orders AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'orders') }}
    ),

renamed_casted AS (
    SELECT
         ORDER_ID
        ,SHIPPING_SERVICE
        ,PROMO_ID
        ,ORDER_COST
        ,TRACKING_ID
        ,ESTIMATED_DELIVERY_AT
        ,USER_ID
        ,SHIPPING_COST
        ,CREATED_AT TIMESTAMP_NTZ
        ,ORDER_TOTAL
        ,STATUS
        ,ADDRESS_ID
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_orders
    )
   -- WHERE ESTIMATED_DELIVERY_AT <> 'NULL'

SELECT * FROM renamed_casted