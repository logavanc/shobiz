## Sho is a simple structured console output library, meant to be used with
## minimal runtime configuration (e.g. `--debug` and `--pretty` flags).
##
## Debug messages are only shown when the `SHO_DEBUG` flag is set.
## The output can be pretty printed by setting the `SHO_PRETTY` flag for easier
## reading, but by default, the output is minified single-line JSON which can be
## easily parsed by other tools (e.g. `jq`) or piped to a file (e.g.
## `> file.jsonl`).
import json
import options
import terminal
import times

import shobiz/colorize

export SHO_BOOL_COLOR
export SHO_KEY_COLOR
export SHO_NULL_COLOR
export SHO_NUMBER_COLOR
export SHO_STRING_COLOR

type
  ShoLevel {.pure.} = enum
    Error   = "Error"
    Message = "Message"
    Debug   = "Debug"

var
  SHO_PRETTY*  = false  ## Pretty print the output.
  SHO_DEBUG*   = false  ## Print debug information.
  SHO_OUTPUT*  = stdout ## Where to write the output.
  SHO_INDENT*  = 4      ## Indentation level for pretty printing.

var
  SHO_USEUTC*  = false                            ## Use UTC time.
  SHO_TIMEFMT* = "yyyy-MM-dd'T'HH:mm:ss'.'fffzzz" ## Time format (default ISO8601).

proc timestamp(): string =
  var dt = now()
  if SHO_USEUTC:
    dt = dt.utc()
  dt.format(SHO_TIMEFMT)

proc sho(
  msg: string,
  level: ShoLevel,
  exType: Option[string] = none(string),
  data: Option[JsonNode] = none(JsonNode)) =
  let node = newJObject()
  node["timestamp"] = %timestamp()
  node["level"] = %level
  if exType.isSome():
    node["type"] = %exType.get()
  node["message"] = %msg
  if data.isSome():
    node["data"] = data.get
  if SHO_PRETTY:
    if SHO_OUTPUT.isatty():
      SHO_OUTPUT.writeLine(node.prettyColor(indent = SHO_INDENT))
    else:
      SHO_OUTPUT.writeLine(node.pretty(indent = SHO_INDENT))
  else:
    SHO_OUTPUT.writeLine($node)

proc shoExc*(err: ref Exception) =
  ## Show an exception message.
  runnableExamples:
    SHO_PRETTY = true

    try:
      raise newException(KeyError, "error")
    except Exception as err:
      err.shoExc()
  ## Produces:
  ## ```json
  ## {
  ##     "timestamp": "2024-05-27T21:57:43.862-07:00",
  ##     "level": "Error",
  ##     "type": "KeyError",
  ##     "message": "error"
  ## }
  ## ```
  sho(
    msg = err.msg,
    level = ShoLevel.Error,
    exType = some($err.name))

proc shoExc*(err: ref Exception, data: JsonNode) =
  ## Show an exception message with additional data.
  runnableExamples:
    import json

    SHO_PRETTY = true

    try:
      raise newException(KeyError, "error")
    except Exception as err:
      err.shoExc(%*{"key": "value"})
  ## Produces:
  ## ```json
  ## {
  ##     "timestamp": "2024-05-27T21:57:43.862-07:00",
  ##     "level": "Error",
  ##     "type": "KeyError",
  ##     "message": "error",
  ##     "data": {
  ##         "key": "value"
  ##     }
  ## }
  ## ```
  sho(
    msg = err.msg,
    level = ShoLevel.Error,
    exType = some($err.name),
    data = some(data))

proc shoMsg*(msg: string) =
  ## Show a message.
  runnableExamples:
    SHO_PRETTY = true

    "Hello, World!".shoMsg()
  ## Produces:
  ## ```json
  ## {
  ##     "timestamp": "2024-05-27T21:57:43.862-07:00",
  ##     "level": "Message",
  ##     "message": "Hello, World!"
  ## }
  ## ```
  sho(
    msg = msg,
    level = ShoLevel.Message)

proc shoMsg*(msg: string, data: JsonNode) =
  ## Show a message with additional data.
  runnableExamples:
    import json

    SHO_PRETTY = true

    "Hello, World!".shoMsg(%*{"key": "value"})
  ## Produces:
  ## ```json
  ## {
  ##     "timestamp": "2024-05-27T21:57:43.862-07:00",
  ##     "level": "Message",
  ##     "message": "Hello, World!",
  ##     "data": {
  ##         "key": "value"
  ##     }
  ## }
  ## ```
  sho(
    msg = msg,
    level = ShoLevel.Message,
    data = some(data))

proc shoDbg*(msg: string) =
  ## Show a debug message.
  ## This message will only be shown if the `SHO_DEBUG` flag is set.
  runnableExamples:
    SHO_PRETTY = true
    SHO_DEBUG = true

    "Detailed message.".shoDbg()
  ## Produces:
  ## ```json
  ## {
  ##     "timestamp": "2024-05-27T21:57:43.862-07:00",
  ##     "level": "Debug",
  ##     "message": "Detailed message."
  ## }
  ## ```
  if SHO_DEBUG:
    sho(
      msg = msg,
      level = ShoLevel.Debug)

proc shoDbg*(msg: string, data: JsonNode) =
  ## Show a debug message with additional data.
  ## This message will only be shown if the `SHO_DEBUG` flag is set.
  runnableExamples:
    import json

    SHO_PRETTY = true
    SHO_DEBUG = true

    "Detailed message.".shoDbg(%*{"key": "value"})
  ## Produces:
  ## ```json
  ## {
  ##     "timestamp": "2024-05-27T21:57:43.862-07:00",
  ##     "level": "Debug",
  ##     "message": "Detailed message.",
  ##     "data": {
  ##         "key": "value"
  ##     }
  ## }
  ## ```
  if SHO_DEBUG:
    sho(
      msg = msg,
      level = ShoLevel.Debug,
      data = some(data))
