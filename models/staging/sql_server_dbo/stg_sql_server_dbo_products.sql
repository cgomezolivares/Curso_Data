WITH src_products AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'products') }}
    ),

renamed_casted AS (
    SELECT
         md5(PRODUCT_ID) as product_id
        ,trim(product_id) as natural_product_id
        ,trim(NAME) as NOMBRE_PRODUCTO
        ,cast(PRICE as number(38,2)) as Precio_usd
        ,INVENTORY AS INVENTARIO
        ,_fivetran_deleted 
        ,_fivetran_synced AS date_load
    FROM src_products
    )

SELECT * FROM renamed_casted