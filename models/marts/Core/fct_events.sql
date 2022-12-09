{{
  config(
    materialized='incremental',
    unique_key=('event_id'),
    on_schema_change ='append_new_columns'
  )
}}
WITH eventos AS (SELECT * FROM {{ ref('stg_sql_server_dbo_events') }})
,

gold_event AS (   
    SELECT
        -- id
       natural_event_ID
      ,event_ID
      ,product_id
      ,user_id
      ,session_id
      ,order_id
        -- strings
      ,page_url
      ,event_type
        -- timestamp
      ,fecha_evento
      ,date_load
    FROM eventos
{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  where date_load >= (select max(date_load) from {{ this }})

{% endif %}

)

SELECT * FROM gold_event