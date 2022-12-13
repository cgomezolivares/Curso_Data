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
  having CHECKOUT_AMOUNT >= (select max(CHECKOUT_AMOUNT) from {{ this }}) 
  or PACKAGE_SHIPPED_AMOUNT >= (select max(PACKAGE_SHIPPED_AMOUNT) from {{ this }})
  or ADD_TO_CART_AMOUNT >= (select max(ADD_TO_CART_AMOUNT) from {{ this }})
  or PAGE_VIEW_AMOUNT >= (select max(PAGE_VIEW_AMOUNT) from {{ this }})
  or total_pedido_usd >= (select max(total_pedido_usd) from {{ this }}) 
  or total_envio_usd >= (select max(total_envio_usd) from {{ this }})
  or total_descuento_usd >= (select max(total_descuento_usd) from {{ this }})
  or total_coste_usd >= (select max(total_coste_usd) from {{ this }})

{% endif %}

)
select * from joined order by 1 asc
