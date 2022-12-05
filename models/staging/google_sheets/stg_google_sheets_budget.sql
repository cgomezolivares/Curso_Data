
{{
  config(
    materialized='view'
  )
}}

WITH src_budget_products AS (
    SELECT * 
    FROM {{ source('google_sheets', 'budget') }}
    ),

renamed_casted AS (
    SELECT
          _row
        , product_id as natural_product_id
        , md5(product_id) as product_id
        , quantity
        , month
        , _fivetran_synced AS date_load
    FROM src_budget_products
    )

SELECT * FROM renamed_casted