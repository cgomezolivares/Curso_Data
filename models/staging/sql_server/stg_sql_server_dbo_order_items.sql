WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

renamed_casted AS (
    SELECT
         ORDER_ID
        ,PRODUCT_ID
        ,QUANTITY AS CANTIDAD
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_order_items
    )

SELECT * FROM renamed_casted