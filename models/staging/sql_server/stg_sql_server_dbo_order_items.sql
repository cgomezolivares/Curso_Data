WITH src_order_items AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'order_items') }}
    ),

renamed_casted AS (
    SELECT
        -- ids
         md5(ORDER_ID) as order_id
        ,md5(PRODUCT_ID) as product_id
        -- strings
        ,cast(QUANTITY as number(38,2)) AS CANTIDAD
        --timestamps
        ,_fivetran_deleted
        ,_fivetran_synced as date_load
    FROM src_order_items
    )

SELECT 

     {{ dbt_utils.surrogate_key(['order_id','product_id'])
    }} as order_items_id
    ,ORDER_ID
    ,PRODUCT_ID
    ,CANTIDAD
    ,_fivetran_deleted
    ,date_load

 from renamed_casted