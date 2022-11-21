WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
         USER_ID
        ,EMAIL
        ,ADDRESS_ID
        ,CREATED_AT
        ,FIRST_NAME
        ,LAST_NAME 
        ,PHONE_NUMBER
        ,UPDATED_AT 
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_users
    )

SELECT * FROM renamed_casted