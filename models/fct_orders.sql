{{
    config (
        materialized = 'table',
        sort = 'order_date'
    )
}}

with stg_orders as (
    select * from {{ ref('stg_orders') }}
)

, payment_info as (
    /* 
    some orders have more than one row in stripe table
    all with the same created_at
    amounts and paymentmethods may vary
    */
    select
        orderid
        , created_at
        , sum(amount) amount 
        , listagg(distinct paymentmethod, ', ') paymentMethods
    from {{ ref('stg_stripe_payments') }}
    {{ dbt_utils.group_by(n=2) }}
)

, orders as (
    select 
        order_id
        , customer_id
        , order_date
        , status 
        , amount 
        , paymentMethods
    from stg_orders
    left join payment_info
        on stg_orders.order_id = payment_info.orderid
)

select * from orders