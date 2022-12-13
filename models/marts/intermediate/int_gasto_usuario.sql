{{
  config(
    materialized='incremental'
    ,unique_key=('user_id')
    ,on_schema_change ='append_new_columns'
  )
}}
WITH dim_order AS (SELECT * FROM {{ ref('stg_sql_server_dbo_orders') }})
    , dim_promo as (SELECT * FROM {{ ref('stg_sql_server_dbo_promos') }} )
    ,


joined AS (   
    SELECT
         a.user_id 
        , a.address_id
        , a.coste_pedido_usd
        , a.coste_envio_usd
        , CASE
          WHEN b.descuento_usd IS NULL THEN '0'
          ELSE b.descuento_usd
          END AS descuento_promo_usd
        , a.coste_total_usd
        , a.date_load


    FROM dim_order a
    left join dim_promo B
    ON A.PROMO_ID = B.PROMO_ID
        

)
,
gasto_usuario as (
    SELECT 
      user_id
      ,sum(coste_pedido_usd) as total_pedido_usd
      ,sum(coste_envio_usd) as total_envio_usd
      ,sum(descuento_promo_usd) as total_descuento_usd
      ,sum(coste_total_usd) as total_coste_usd
    FROM joined 
    group by 1 
    order by 1 asc

)

Select * from gasto_usuario
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  having total_pedido_usd >= (select max(total_pedido_usd) from {{ this }}) 
  or total_envio_usd >= (select max(total_envio_usd) from {{ this }})
  or total_descuento_usd >= (select max(total_descuento_usd) from {{ this }})
  or total_coste_usd >= (select max(total_coste_usd) from {{ this }})

{% endif %}
