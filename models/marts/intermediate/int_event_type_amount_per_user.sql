{{
  config(
    materialized='incremental',
    unique_key=('user_id'),
    on_schema_change ='append_new_columns'
  )
}}

{% set event_types = ["checkout", "package_shipped", "add_to_cart","page_view"] %}

WITH stg_events AS (

    SELECT *

    FROM {{ ref('stg_sql_server_dbo_events') }}

    ),



renamed_casted AS (

    SELECT

        user_id,
        

        {%- for event_type in event_types   %}

        sum(case when event_type = '{{event_type}}' then 1 else 0 end) as {{event_type}}_amount

        {%- if not loop.last %},{% endif -%}

        {% endfor %}


    FROM stg_events

    GROUP BY 1

{% if is_incremental() %}

  -- this filter will only be applied on an incremental run
  having CHECKOUT_AMOUNT >= (select max(CHECKOUT_AMOUNT) from {{ this }}) 
  or PACKAGE_SHIPPED_AMOUNT >= (select max(PACKAGE_SHIPPED_AMOUNT) from {{ this }})
  or ADD_TO_CART_AMOUNT >= (select max(ADD_TO_CART_AMOUNT) from {{ this }})
  or PAGE_VIEW_AMOUNT >= (select max(PAGE_VIEW_AMOUNT) from {{ this }})

{% endif %}

)
SELECT * FROM renamed_casted

