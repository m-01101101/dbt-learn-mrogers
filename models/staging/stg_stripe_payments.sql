
    select
        "ID" id 
        , "orderID" orderid
        , "CREATED" created_at
        , "paymentMethod" paymentmethod
        -- assume in cents
        , "AMOUNT" amount
    from {{ source ('stripe', 'payment') }}