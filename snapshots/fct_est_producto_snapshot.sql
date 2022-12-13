{% snapshot fct_estadisticas_producto_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key= "order_id||'-'||product_id" ,
      strategy='timestamp',
      updated_at='date_load',
      invalidate_hard_deletes=True,
    )
}}

select   order_id||'-'||product_id, ,* from {{ ref('fct_estadisticas_producto') }}

{% endsnapshot %}