  
{%- set payment_methods = ['bank_transfer', 'credit_card', 'gift_card', 'coupon'] -%}

select
    orderid
    {%- for payment_method in payment_methods %}
    , sum(case when paymentmethod = '{{payment_method}}' then amount end) {{payment_method}}_amount
    {% endfor %}
    {#-
        you can do something like "{% ',' if not loop.last %}" or "{%- if not loop.last %},{% endif -%}" 
        if using trailing commas
    -#}
    , sum(amount) total_amount
from {{ ref('stg_stripe_payments') }}
group by 1