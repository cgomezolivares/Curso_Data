
{{
  config(
    materialized='view'
  )
}}

WITH src_city AS (
    SELECT * 
    FROM {{ source('google_sheets', 'cities') }}
    ),

renamed_casted AS (
    SELECT
          ZIP AS Codigo_postal
        , State as Estado
        , City as Ciudad
        , County_name as Condado
        , _fivetran_synced AS date_load
    FROM src_city
    )

SELECT * FROM renamed_casted
/* algunos condados y ciudad_est son vacios pero no influyen porque no se van a utilizar esas columnas */ 