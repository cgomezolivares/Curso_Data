{{
  config(
    materialized='view'
  )
}}
WITH int_event AS (SELECT * FROM {{ ref('int_event_type_amount_per_user') }})
    , int_coste as (SELECT * FROM {{ ref('int_gasto_usuario') }} )
    ,


joined AS (   
    SELECT
      a.user_id
      ,a.checkout_amount
      ,a.package_shipped_amount
      ,a.add_to_cart_amount
      ,a.page_view_amount
      ,b.total_pedido_usd
      ,b.total_envio_usd
      ,b.total_descuento_usd
      ,b.total_coste_usd
    FROM int_event a
    Left join int_coste b
    on a.user_id=b.user_id
)
select * from joined order by 1 asc
