{{
  config(
    materialized='table'
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
    )

SELECT * FROM int_pu