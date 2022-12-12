WITH src_events AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'events') }}
    ),

renamed_casted AS (
    SELECT
        -- IDs
         trim(event_id) as natural_event_id
        ,md5(event_id) as event_id
        ,md5(product_id) as product_id
        ,md5(user_id) as user_id
        ,md5(session_id) as session_id
        ,md5(order_id) as order_id

        -- strings
        ,trim(page_url) as page_url
        ,trim(event_type) as event_type

        -- timestamp
        ,created_at as fecha_evento
        ,_fivetran_deleted
        ,_fivetran_synced as date_load
    FROM src_events
    )

SELECT * FROM renamed_casted