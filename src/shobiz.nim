import json
import options
import times

type
  ShoLevel {.pure.} = enum
    Error = "Error"
    Message = "Message"
    Verbose = "Verbose"

var
  SHO_PRETTY* = false ## pretty print the output
  SHO_VERBOSE* = false ## print debug information
  SHO_OUTPUT* = stdout ## where to write the output

var
  SHO_USEUTC* = false ## use UTC time
  SHO_TIMEFMT* = "yyyy-MM-dd'T'HH:mm:ss'.'fffzzz" ## time format (default ISO8601)

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
  SHO_OUTPUT.writeLine(
    if SHO_PRETTY: node.pretty(indent = 4)
    else: $node)

proc shoExc*(err: ref Exception) =
  sho(
    msg = err.msg,
    level = ShoLevel.Error,
    exType = some($err.name))

proc shoExc*(err: ref Exception, data: JsonNode) =
  sho(
    msg = err.msg,
    level = ShoLevel.Error,
    exType = some($err.name),
    data = some(data))

proc shoMsg*(msg: string) =
  sho(
    msg = msg,
    level = ShoLevel.Message)

proc shoMsg*(msg: string, data: JsonNode) =
  sho(
    msg = msg,
    level = ShoLevel.Message,
    data = some(data))

proc shoDbg*(msg: string) =
  if SHO_VERBOSE:
    sho(
      msg = msg,
      level = ShoLevel.Verbose)

proc shoDbg*(msg: string, data: JsonNode) =
  if SHO_VERBOSE:
    sho(
      msg = msg,
      level = ShoLevel.Verbose,
      data = some(data))
