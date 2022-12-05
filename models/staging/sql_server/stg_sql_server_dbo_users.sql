WITH src_users AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'users') }}
    ),

renamed_casted AS (
    SELECT
         md5(USER_ID) as user_id
        ,trim(user_id) as natural_user_id
        ,md5(ADDRESS_ID) as ADDRESS_ID
        ,trim(FIRST_NAME) AS NOMBRE
        ,trim(LAST_NAME) AS APELLIDO
        ,PHONE_NUMBER AS TELEFONO
        ,trim(EMAIL) as email
        ,UPDATED_AT AS ULTIMA_ACTUALIZACION
        ,CREATED_AT AS FECHA_CREACION
        ,_fivetran_deleted
        ,_fivetran_synced as date_load
    FROM src_users
    )

SELECT * FROM renamed_casted