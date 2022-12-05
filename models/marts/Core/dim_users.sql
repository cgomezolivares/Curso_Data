{{
  config(
    materialized='table'
  )
}}
WITH dim_user AS (SELECT * FROM {{ ref('stg_sql_server_dbo_users') }})
,

gold_user AS (   
    SELECT
       USER_ID
      ,NATURAL_USER_ID
      ,NOMBRE
      ,APELLIDO
      ,TELEFONO
      ,EMAIL
      ,ADDRESS_ID
      ,FECHA_CREACION
      ,ULTIMA_ACTUALIZACION
      ,date_load

    FROM dim_user 
    )

SELECT * FROM gold_user