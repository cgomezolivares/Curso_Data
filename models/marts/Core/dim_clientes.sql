
{{
  config(
    materialized='table'
  )
}}
WITH dim_user AS (SELECT * FROM {{ ref('stg_sql_server_dbo_users') }})
    , dim_addresses as (SELECT * FROM {{ ref('stg_sql_server_dbo_addresses') }} ),

joined AS (   
    SELECT
          a.USER_ID
        , a.NOMBRE
        , a.APELLIDO
        , b.DIRECCION
        , b.ESTADO
        , b.PAIS
        , a.EMAIL
        , a.PHONE_NUMBER as TELEFONO
        , a.CREATED_AT AS FECHA_CREACION
        , a.UPDATED_AT 

    FROM dim_user a
    inner join dim_addresses B
    ON A.ADDRESS_ID = B.ADDRESS_ID
    )

SELECT * FROM joined