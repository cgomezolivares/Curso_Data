-- This refers to the table created from seeds/ciudades.csv

{{
  config(
    materialized='view'
  )
}}

WITH src_city AS (
    SELECT * 
    FROM {{ ref('Ciudades') }}
    ),

renamed_casted AS (
    SELECT
          ZIP AS Codigo_postal
        , City as Ciudad
        , State as Estado
        , County_name as Condado
    FROM src_city
    )

SELECT * FROM renamed_casted