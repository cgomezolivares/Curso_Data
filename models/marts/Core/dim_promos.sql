{{
  config(
    materialized='table'
  )
}}
WITH dim_promo AS (SELECT * FROM {{ ref('stg_sql_server_dbo_promos') }})
,

gold_promo AS (   
    SELECT
       promo_id
      ,natural_promo_id
	    ,estado_promo
	    ,descuento_usd
      ,_fivetran_deleted
      ,date_load

    FROM dim_promo
    )

SELECT * FROM gold_promo