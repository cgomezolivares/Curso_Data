WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
         PRODUCT_ID
        ,PRICE as Precio_$
        ,NAME as NOMBRE_PRODUCTO
        ,INVENTORY NUMBER
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_products
    )

SELECT * FROM renamed_casted