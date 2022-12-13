SELECT *
FROM {{ ref('stg_sql_server_dbo_orders') }}
having fecha_envio_estimada_utc < fecha_pedido_utc
/* comprueba si hay algún caso en el que la fecha de entrega sea anterior a la fecha en que se realizó el pedido, lo que no tendría sentido lógico e indicaría algún tipo de problema con los datos */