WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
         PRODUCT_ID
        ,PRICE as Precio_usd
        ,NAME as NOMBRE_PRODUCTO
        ,INVENTORY AS NUM_INVENTARIO
        ,_fivetran_deleted 
        ,_fivetran_synced AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted