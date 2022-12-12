{% snapshot estadisticas_user_snapshot %}

{{
    config(
      target_schema='snapshots',
      unique_key='user_id',
      strategy='check',
      check_cols= ['checkout_amount'
        ,'add_to_cart_amount'
        ,'package_shipped_amount','page_view_amount'
        ,'total_pedido_usd','total_envio_usd'
        ,'total_descuento_usd'
        ,'total_coste_usd'
      ],
      invalidate_hard_deletes=True,
    )
}}
--IF DAY(GETDATE())=1
  select * from {{ ref('fct_estadisticas_usuario') }}


{% endsnapshot %}