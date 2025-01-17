{ name = "my-project"
, dependencies =
  [ "aff"
  , "argonaut-codecs"
  , "argparse-basic"
  , "arrays"
  , "bifunctors"
  , "console"
  , "control"
  , "datetime"
  , "effect"
  , "either"
  , "exceptions"
  , "fetch"
  , "filterable"
  , "foldable-traversable"
  , "foreign"
  , "formatters"
  , "integers"
  , "maybe"
  , "newtype"
  , "node-buffer"
  , "node-execa"
  , "node-fs"
  , "node-path"
  , "node-process"
  , "nullable"
  , "parsing"
  , "precise-datetime"
  , "prelude"
  , "strings"
  , "transformers"
  , "tuples"
  , "versions"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "bin/**/*.purs" ]
}
