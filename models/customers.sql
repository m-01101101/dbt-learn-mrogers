{{
    config (
        materialized = 'table'
    )
}}

    with customers as (
        select * from {{ ref('stg_customers') }}
    )
    
    , orders as (
        select * from {{ ref('orders') }}
    )
    
    , customer_orders as (
        select
            customer_id
            , min(order_date) first_order_date
            , max(order_date) most_recent_order_date
            , count(order_id) number_of_orders
            , sum(amount) lifetime_spend
        from orders
        group by 1
    )
    
    , final as (
        select
            customers.customer_id
            , customers.first_name
            , customers.last_name
            , customer_orders.first_order_date
            , customer_orders.most_recent_order_date
            , coalesce(customer_orders.number_of_orders, 0) as number_of_orders
            , coalesce(customer_orders.lifetime_spend, 0) as lifetime_spend
        from customers
            left join customer_orders using (customer_id) 
    )

    select * from final