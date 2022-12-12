{{
  config(
    materialized='incremental',
    unique_key=('order_items_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH dim_order_items AS (SELECT * FROM {{ ref('stg_sql_server_dbo_order_items') }})
,

gold_oi AS (   
    SELECT
        order_items_id 
        ,order_id
        ,product_id
        ,CANTIDAD
        ,date_load
    FROM dim_order_items
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}
)

SELECT * FROM gold_oi