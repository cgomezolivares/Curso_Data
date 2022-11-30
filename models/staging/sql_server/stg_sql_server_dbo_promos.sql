WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        PROMO_ID
	    ,STATUS AS ESTADO_PROMO
	    ,DISCOUNT AS DESCUENTO_usd
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_promos
    )

SELECT * FROM renamed_casted