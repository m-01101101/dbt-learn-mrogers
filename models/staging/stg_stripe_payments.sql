
    select
        "ID" id 
        , "orderID" orderID
        , "CREATED" created_at
        , "paymentMethod" paymentMethod
        , "AMOUNT" amount
    from {{ source ('stripe', 'payment') }}