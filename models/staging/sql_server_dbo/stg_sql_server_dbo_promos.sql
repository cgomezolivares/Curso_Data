WITH src_promos AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'promos') }}
    ),

renamed_casted AS (
    SELECT
        md5(PROMO_ID) as promo_id
        ,trim(promo_id) as natural_promo_id
	    ,trim(STATUS) AS estado_promo
	    ,cast(DISCOUNT as number(38,2)) AS descuento_usd
        ,_fivetran_deleted
        ,_fivetran_synced as date_load
    FROM src_promos
    )

SELECT * FROM renamed_casted