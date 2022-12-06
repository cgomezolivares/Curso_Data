{{
  config(
    materialized='incremental',
    unique_key=('user_id')
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
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}

)

SELECT * FROM gold_user