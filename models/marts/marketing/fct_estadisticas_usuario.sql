{{
  config(
    materialized='incremental',
    unique_key=('user_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH int_event AS (SELECT * FROM {{ ref('int_event_type_amount_per_user') }})
    , int_coste as (SELECT * FROM {{ ref('int_gasto_usuario') }} )
    , dim_user as (SELECT * FROM {{ ref('dim_users') }} )
    , int_order_items AS (SELECT * FROM {{ ref('int_product_per_user') }})
    ,

joined AS (   
    SELECT
      c.user_id
      ,c.address_id
      ,a.checkout_amount
      ,a.package_shipped_amount
      ,a.add_to_cart_amount
      ,a.page_view_amount
      ,b.total_pedido_usd
      ,b.total_envio_usd
      ,b.total_descuento_usd
      ,b.total_coste_usd
      ,d.cantidad_producto
    FROM int_event a
    Left join int_coste b
    on a.user_id=b.user_id
    join dim_user c
    on a.user_id=c.user_id
    join int_order_items d 
    on c.user_id=d.user_id

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where [total_coste_usd,{{event_type}}_amount] >= (select max([total_coste_usd,{{event_type}}_amount]) from {{ this }})

{% endif %}

)
select * from joined order by 1 asc
