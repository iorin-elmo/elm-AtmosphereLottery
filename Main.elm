module Main exposing (..)

import Browser
import Html exposing (Html, button, div, text, br, select, option, span)
import Html.Attributes exposing (type_, style, value)
import Html.Events exposing (onClick, onInput)
import ListWrapper.Set as LWset

import Random
import Data exposing(..)

type alias Model =
  { result : List Gases
  , selectedLottery : List (Float, Gases)
  , times : Int
  , showParcentage : Bool
  , gasFilter : LWset.Set Gases
  }

initModel : Model
initModel =
  { result = []
  , selectedLottery = earthAtmosphere
  , times = 1
  , showParcentage = False
  , gasFilter =
      earthAtmosphere
        |> List.unzip
        |> Tuple.second
        |> LWset.fromList
  }

type Msg
  = StartLottery
  | SwitchView
  | ChangeTimes String
  | ChangeFilter Gases
  | ChangePlanet String
  | ClearResult
  | StoreResult (List Gases)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    StartLottery ->
      let
        lottery =
          case model.selectedLottery of
            hd::tl -> Random.weighted hd tl
            [] -> Random.constant [("",0)]
      in
        ( model
        , Random.generate StoreResult
          (Random.list model.times lottery) )
    SwitchView ->
      ( { model
        | showParcentage =
          not model.showParcentage }
      , Cmd.none )
    ChangeTimes str ->
      ( { model
        | times =
          Maybe.withDefault 1
          (String.toInt str) }
      , Cmd.none )
    ChangeFilter gas ->
      ( { model
        | gasFilter =
          if LWset.member gas model.gasFilter
          then LWset.remove gas model.gasFilter
          else LWset.insert gas model.gasFilter
        }
      , Cmd.none )
    ChangePlanet str ->
      let
        planet =
          case str of
            "earth" -> earthAtmosphere
            "mars"  -> marsAtmosphere
            _ -> []
      in
        ( { model
          | selectedLottery = planet
          , result = []
          , gasFilter =
              planet
                |> List.unzip
                |> Tuple.second
                |> LWset.fromList
          }
        , Cmd.none )
    ClearResult ->
      ( { model
        | result = [] }
      , Cmd.none )
    StoreResult li ->
      ( { model
        | result = model.result ++
          List.filter
            (\gas ->
              LWset.member gas model.gasFilter )
            li }
      , Cmd.none )

view : Model -> Html Msg
view model =
  let
    makeSelectOption num =
      List.range 0 num
        |> List.map
          (\n ->
            option
              [ value
                <| String.fromInt (10^n) ]
              [ text
                <| String.fromInt (10^n) ]
          )
  in
    div []
      <| List.append
        [ button
          [ onClick StartLottery ]
          [ text "StartLottery" ]
        , button
          [ onClick ClearResult ]
          [ text "ClearResult" ]
        , button
          [ onClick SwitchView ]
          [ text
            ( if model.showParcentage
              then "hide %"
              else "show %" ) ]
        , select
          [ onInput ChangeTimes ]
          <| makeSelectOption 5
        , select
          [ onInput ChangePlanet ]
          [ option [ value "earth" ][ text "earth" ]
          , option [ value "mars" ] [ text "mars" ]
          ]
        , br [][]
        ]
        ( if model.showParcentage
          then
            [ text "Emission Rates", br [][]
            , text "Red : Hidden, Black : Shown", br [][] ] ++
            ( model.selectedLottery
                |> List.map
                  (\(p, gas) ->
                    [ button
                      [ onClick <| ChangeFilter gas ]
                      [ text
                        <| if LWset.member gas model.gasFilter
                          then "H"
                          else "S"
                      ]
                    , span
                      [ style "color"
                        <| if LWset.member gas model.gasFilter
                        then "black" else "red" ]
                      [ text <| String.padRight 5 '…' (gases2Str gas) 
                      , text <| String.fromFloat p ++ "%" 
                      ]
                    ]
                  )
                |> List.intersperse [ br [][] ]
                |> List.concat
            )
          else
            [ text "Result", br[][] ] ++
            ( List.map (gases2Str >> text) model.result
              |> List.intersperse (br[][]) )
        )

gases2Str : Gases -> String
gases2Str gas =
  gas
    |> List.foldl
      (\(el, n) str ->
        str ++
        el ++
          if n > 1 && n < 10
          then
            String.fromChar
              (Char.fromCode (8320 + n))
          else
            ""
      )
      ""

main : Program () Model Msg
main =
  Browser.element
    { init = \_ -> ( initModel, Cmd.none )
    , view = view
    , update = update
    , subscriptions = \_ -> Sub.none
    }