{% snapshot orders_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='order_id',
      strategy='timestamp',
      updated_at='date_load',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ ref('fct_orders') }}

{% endsnapshot %}