module Data exposing
  ( Element
  , Gases
  , earthAtmosphere
  , marsAtmosphere
  )

type alias Element
  = String

type alias Gases
  = List (Element, Int)

earthAtmosphere : List ( Float, Gases )
earthAtmosphere =
    [ ( 78.084    , [("N", 2)] )
    , ( 20.9476   , [("O", 2)] )
    , (  0.9340   , [("Ar",1)] )
    , (  0.0390   , co2      )
    , (  0.001818 , [("Ne",1)] )
    , (  0.000524 , [("He",1)] )
    , (  0.000181 , methane  )
    , (  0.000114 , [("Kr",1)] )
    , (  0.0001   , so2      )
    , (  0.00005  , [("H", 2)] )
    , (  0.000032 , n2o      )
    , (  0.0000087,[ ("Xe",1)] )
    , (  0.000007 , [("O", 3)] )
    , (  0.000002 , no2      )
    , (  0.000001 , [("I", 2)] )
    ]

marsAtmosphere : List ( Float, Gases )
marsAtmosphere =
  [ ( 95.32        , co2      )
  , (  2.7         , [("N", 2)] )
  , (  1.6         , [("Ar",1)] )
  , (  0.13        , [("O", 2)] )
  , (  0.07        , co       )
  , (  0.03        , water    )
  , (  0.013       , no       )
  , (  0.0000025   , [("Ne",1)] )
  , (  0.0000003   , [("Kr",1)] )
  , (  0.00000013  , ch2o     )
  , (  0.00000008  , [("Xe",1)] )
  , (  0.00000003  , [("O", 3)] )
  , (  0.0000000105, methane  )
  ]


co2 =
  [("C", 1), ("O", 2)]
so2 =
  [("S", 1), ("O", 2)]
n2o =
  [("N", 2), ("O", 1)]
no2 =
  [("N", 1), ("O", 2)]
water =
  [("H", 2), ("O", 1)]
methane =
  [("C", 1), ("H", 4)]
co =
  [("C", 1), ("O", 1)]
no =
  [("N", 1), ("O", 1)]
ch2o =
  [("C", 1), ("H", 2), ("O", 1)]