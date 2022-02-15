module Main where

import Prelude

import ArgParse.Basic as Arg
import Bin.Version (version)
import Data.Array as Array
import Data.Either (Either(..))
import Data.String as String
import Effect (Effect)
import Effect.Aff (launchAff_)
import Effect.Class.Console as Console
import Node.Path (sep)
import Node.Process as Process
import UpChangelog.Command.GenChangelog (genChangelog)
import UpChangelog.Command.InitChangelog (initChangelog)
import UpChangelog.Constants as Constants
import UpChangelog.Types (GenChangelogArgs(..))

main :: Effect Unit
main = do
  args <- Array.drop 2 <$> Process.argv
  case parseCliArgs args of
    Left err -> do
      Console.log $ Arg.printArgError err
      case err of
        Arg.ArgError _ Arg.ShowHelp ->
          Process.exit 0
        Arg.ArgError _ (Arg.ShowInfo _) ->
          Process.exit 0
        _ ->
          Process.exit 1
    Right cmd ->
      case cmd of
        GenChangelog options -> do
          launchAff_ $ genChangelog options

        InitChangelog force -> do
          launchAff_ $ initChangelog force

data Command
  = InitChangelog Boolean
  | GenChangelog GenChangelogArgs

parseCliArgs :: Array String -> Either Arg.ArgError Command
parseCliArgs = Arg.parseArgs
  "purs-changelog"
  ( String.joinWith "\n"
      [ "A CLI for updating the `CHANGELOG.md` file when making a new release."
      , ""
      , "Examples:"
      , "  purs-changelog init"
      , "  purs-changelog regenerate --owner purescript --repo prelude"
      ]
  )
  cliParser

cliParser :: Arg.ArgParser Command
cliParser =
  Arg.choose "command"
    [ Arg.command [ "regenerate", "r" ] "Regenerates the CHANGELOG.md file based on files in CHANGELOG.d/" ado
        github <- Arg.fromRecord { owner, repo }
        packageJson <- packageJsonArg
        Arg.flagHelp
        in GenChangelog (GenChangelogArgs { github, packageJson })
    , Arg.command [ "init", "i" ] "Sets up the repo so that the `regenerate` command will work in the future." ado
        force <- forceArg
        Arg.flagHelp
        in InitChangelog force
    ]
    <* Arg.flagHelp
    <* Arg.flagInfo [ "--version", "-v" ] "Shows the current version" version
  where
  owner =
    Arg.argument [ "--owner", "-o" ] "The GitHub repo's owner or username."

  repo =
    Arg.argument [ "--repo", "-r" ] "The GitHub repo's repo name."

  packageJsonArg =
    Arg.argument [ "--package-json", "-j" ] "The path to the `package.json` file (defaults to `package.json`)."
      # Arg.default "package.json"

  forceArg =
    Arg.flag [ "--force", "-f" ] desc
      # Arg.boolean
    where
    desc = "When enabled, overwrites the " <> Constants.changelogDir <> sep <> Constants.readmeFile <> " file if it exists."
