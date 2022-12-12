{% snapshot dim_addresses_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='natural_address_id',
      strategy='timestamp',
      updated_at='date_load',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ ref('dim_addresses') }}

{% endsnapshot %}