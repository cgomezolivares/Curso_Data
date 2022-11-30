{{
  config(
    materialized='table'
  )
}}
WITH dim_user AS (SELECT * FROM {{ ref('stg_sql_server_dbo_order_items') }})
,

gold_order_items AS (   
    SELECT
         ORDER_ID
        ,PRODUCT_ID
        ,CANTIDAD

    FROM dim_user 
    )

SELECT * FROM gold_order_items