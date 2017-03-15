module App exposing (..)

-- LOCAL

import Context exposing (child, with, withIndex)


-- EXTERNAL

import Html exposing (..)
import Material
import Material.Button as Button
import Material.Color as Color
import Material.Scheme
import Material.Layout as Layout
import Material.Options as Options


type alias Context =
    Context.Context Material.Model Msg


type alias Model =
    { counterOne : Int
    , counterTwo : Int
    , mdl : Material.Model
    }


init : Model
init =
    { counterOne = 0
    , counterTwo = 0
    , mdl = Material.model
    }


type Counter
    = CounterOne
    | CounterTwo


type Msg
    = Mdl (Material.Msg Msg)
    | Increment Counter
    | Decrement Counter


view : Model -> Html Msg
view model =
    let
        context =
            Context.init Mdl model.mdl
    in
        (Layout.render |> with context)
            [ Layout.fixedHeader
            ]
            { header = []
            , drawer = []
            , tabs = ( [], [] )
            , main = body context model
            }
            |> Material.Scheme.topWithScheme Color.Blue Color.LightGreen


body : Context -> Model -> List (Html Msg)
body context model =
    [ viewCounter (child context 0) model.counterOne CounterOne
    , viewCounter (child context 1) model.counterTwo CounterTwo
    ]


viewCounter : Context -> Int -> Counter -> Html Msg
viewCounter context value counter =
    Options.div []
        [ button (child context 0) "-" (Decrement counter)
        , value |> toString |> text
        , button (child context 1) "+" (Increment counter)
        ]


button : Context -> String -> Msg -> Html Msg
button context label action =
    (Button.render |> withIndex context 0)
        [ Button.ripple, Options.onClick action ]
        [ text label ]


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment counter ->
            case counter of
                CounterOne ->
                    { model | counterOne = model.counterOne + 1 } ! []

                CounterTwo ->
                    { model | counterTwo = model.counterTwo + 1 } ! []

        Decrement counter ->
            case counter of
                CounterOne ->
                    { model | counterOne = model.counterOne - 1 } ! []

                CounterTwo ->
                    { model | counterTwo = model.counterTwo - 1 } ! []

        Mdl mdlMsg ->
            Material.update Mdl mdlMsg model


main : Program Never Model Msg
main =
    Html.program
        { init = init ! []
        , view = view
        , subscriptions = always Sub.none
        , update = update
        }
