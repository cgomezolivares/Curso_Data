WITH src_fivetran_audit AS (
    SELECT * 
    FROM {{ source('sql_server_dbo', 'fivetran_audit') }}
    ),

renamed_casted AS (
    SELECT
	    ID 
	    ,UPDATE_STARTED 
	    ,UPDATE_ID
	    ,SCHEMA
	    ,"TABLE"
	    ,"START" 
	    ,DONE 
	    ,ROWS_UPDATED_OR_INSERTED
	    ,STATUS
	    ,PROGRESS 
        ,_fivetran_synced
    FROM src_fivetran_audit
    )

SELECT * FROM renamed_casted