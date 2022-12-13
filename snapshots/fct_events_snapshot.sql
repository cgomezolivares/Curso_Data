{% snapshot fct_events_snapshot %}

{{
    config(
      target_schema='fct_events',
      unique_key='event_id',
      strategy='timestamp',
      updated_at='date_load',
      invalidate_hard_deletes=True,
    )
}}

select * from {{ ref('fct_events') }}

{% endsnapshot %}