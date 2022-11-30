
{{
  config(
    materialized='table'
  )
}}
WITH dim_addresses as (SELECT * FROM {{ ref('stg_sql_server_dbo_addresses') }} )
    ,

DIRECCIONES AS (   
    SELECT
        ADDRESS_ID
        , DIRECCION
        , ESTADO
        , PAIS
        , CODIGO_POSTAL

    FROM  dim_addresses B
    )

SELECT * FROM DIRECCIONES