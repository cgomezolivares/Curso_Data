{{
  config(
    materialized='incremental',
    unique_key=('promo_id')
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
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}
    )

SELECT * FROM gold_promo