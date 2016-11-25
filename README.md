A collection of helpers for dealing with elm-mdl render functions.
This is motivated by the following observations:

- The triplet of `Mdl index model.mdl` occurs frequently in elm-mdl.
- Dealing with indices is a bit tedious.

```elm
viewButton model index =
    Button.render Mdl (0 :: index) model.mdl
        [ Button.onClick Increment ]
        [ text "Add" ]
```

This becomes

```elm
viewButton context model =
    (Button.render |> with context)
    Button.render Mdl (0 :: index) model.mdl
        [ Button.onClick Increment ]
        [ text "Add" ]
```

Usage:

```bash
$ elm-make src/App.elm
```
