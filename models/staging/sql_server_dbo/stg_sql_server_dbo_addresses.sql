WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
        --id
        md5(ADDRESS_ID) AS ADDRESS_ID
        ,TRIM(ADDRESS_ID) AS NATURAL_ADDRESS_ID

        -- strings 
        ,TRIM(ADDRESS) AS DIRECCION
        ,TRIM(COUNTRY) AS PAIS
        ,TRIM(STATE) AS ESTADO

        -- number
        ,CAST (ZIPCODE AS NUMBER (38,2))as CODIGO_POSTAL
        
        -- timestamps
        ,_fivetran_deleted
        ,_fivetran_synced as date_load

    FROM src_addresses
    )

SELECT * FROM renamed_casted