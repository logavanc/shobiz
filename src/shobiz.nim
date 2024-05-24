import times
import json

import pretty

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

proc sho(msg: string, level: ShoLevel, data: JsonNode) =
  var node = %{
    "timestamp": %timestamp(),
    "level": %level,
    "message": %msg,
    "data": data
  }
  print(node)

proc shoErr*(err: ref Exception, data: JsonNode = newJNull()) =
  sho(err.msg, ShoLevel.Error, data)

proc shoMsg*(msg: string, data: JsonNode = newJNull()) =
  sho(msg, ShoLevel.Message, data)

proc shoDbg*(msg: string, data: JsonNode = newJNull()) =
  if SHO_VERBOSE:
    sho(msg, ShoLevel.Verbose, data)
