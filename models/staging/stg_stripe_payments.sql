
    select
        *
        -- error message when calling columns explicitly 
    from {{ source ('stripe', 'payment') }}