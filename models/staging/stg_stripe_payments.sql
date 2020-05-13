
    select
        "ID" id 
        , "orderID" orderid
        , "CREATED" created_at
        , "paymentMethod" paymentmethod
        -- assumed dollars - jaffles be costly
        , "AMOUNT" amount
    from {{ source ('stripe', 'payment') }}