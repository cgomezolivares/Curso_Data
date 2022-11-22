WITH src_addresses AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'addresses') }}
    ),

renamed_casted AS (
    SELECT
         ADDRESS_ID
        ,ZIPCODE as CODIGO_POSTAL
        ,ADDRESS AS DIRECCION
        ,COUNTRY AS PAIS
        ,STATE AS ESTADO
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_addresses
    )

SELECT * FROM renamed_casted