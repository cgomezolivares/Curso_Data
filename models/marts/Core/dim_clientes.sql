
{{
  config(
    materialized='view'
  )
}}
WITH dim_user AS (SELECT * FROM {{ ref('dim_users') }})
    , dim_addresses as (SELECT * FROM {{ ref('dim_addresses') }} )
    ,

joined AS (   
    SELECT
          a.USER_ID
        , a.NOMBRE
        , a.APELLIDO
        , b.DIRECCION
        , b.CIUDAD
        , b.CODIGO_POSTAL
        , b.ESTADO
        , b.PAIS
        , a.EMAIL
        , a.TELEFONO
        , a.FECHA_CREACION
        , a.ULTIMA_ACTUALIZACION

    FROM dim_user a
    inner join dim_addresses B
    ON A.ADDRESS_ID = B.ADDRESS_ID
    )

SELECT * FROM joined