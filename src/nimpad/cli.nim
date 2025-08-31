import
  std / [
    os,
    strformat,
    parseopt
  ]

import constants


type
  CliArgs* = object
    file*: string
    loglevel*: string = "info"
    timestamps*: bool = false
    port*: string = "/dev/ttyACM0"


proc cliHelp(): void =
  echo """
Usage: nimpad [Options]

Options:
  -h, --help                  Show help and exit
  -v, --version               Show version and exit
  -t, --timestamps            Print timestamps when logging
  -p=PORT, --port=PORT        The serial port to use
  -l=LVL, --log=LVL           Logging level. One of "debug", "info" (default), "notice", "warn", "error", "fatal", "none"
  -f=FILE, --file=FILE        Location of the configuration file
"""
  quit(0)

proc cliVersion(): void =
  echo fmt"Nimpad {RELEASE_VERSION}"
  quit(0)

proc processCliArgs*(): CliArgs =
  var cliArgs: CliArgs

  for kind, key, val in getopt():
    case kind
      of cmdArgument: assert(false)
      of cmdShortOption, cmdLongOption:
        case key
          of "h", "help":
            cliHelp()
          of "v", "version":
            cliVersion()
          of "t", "timestamps":
            cliArgs.timestamps = true
          of "p", "port":
            cliArgs.port = val
          of "l", "log-level":
            cliArgs.loglevel = val
          of "f", "file":
            cliArgs.file = expandTilde(val)
      of cmdEnd: assert(false)
  return cliArgs

