{{
  config(
    materialized='incremental',
    unique_key=('user_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH dim_oi AS (SELECT * FROM {{ ref('stg_sql_server_dbo_order_items') }})
    ,dim_o AS (SELECT * FROM {{ ref('stg_sql_server_dbo_orders') }})
    ,

int_pu AS (   
    SELECT
        a.user_id

        ,sum(b.CANTIDAD) as cantidad_producto


    FROM dim_o A
    join dim_oi b
    on a.order_id=b.order_id
    group by 1
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where cantidad_producto >= (select max(cantidad_producto) from {{ this }})

{% endif %}

)
SELECT * FROM int_pu