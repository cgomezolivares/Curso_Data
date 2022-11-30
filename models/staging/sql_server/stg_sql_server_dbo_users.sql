WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
         USER_ID
        ,EMAIL
        ,ADDRESS_ID
        ,CREATED_AT AS FECHA_CREACION
        ,FIRST_NAME AS NOMBRE
        ,LAST_NAME AS APELLIDO
        ,PHONE_NUMBER AS TELEFONO
        ,UPDATED_AT AS ULTIMA_ACTUALIZACION
        ,_fivetran_deleted
        ,_fivetran_synced
    FROM src_users
    )

SELECT * FROM renamed_casted