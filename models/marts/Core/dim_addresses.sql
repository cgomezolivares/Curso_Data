
{{
  config(
    materialized='incremental',
    unique_key=('address_id')
  )
}}
WITH dim_addresses as (SELECT * FROM {{ ref('stg_sql_server_dbo_addresses') }} )
    , dim_city as (SELECT * FROM {{ ref('stg_seed_ciudades') }} )
    ,

DIRECCIONES AS (   
    SELECT
          A.NATURAL_ADDRESS_ID
        , A.ADDRESS_ID
        , A.DIRECCION
        , B.CIUDAD
        , A.ESTADO
        , A.PAIS
        , A.CODIGO_POSTAL
        , A.DATE_LOAD

    FROM  dim_addresses A
    LEFT JOIN dim_city b
    on A.CODIGO_POSTAL=B.Codigo_postal

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}
    )

SELECT * FROM DIRECCIONES

