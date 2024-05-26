import tables
import unittest
import json

import shobiz

let data = %* {
  "null": nil,
  "string": "string",
  "int": 2,
  "float": 3.14,
  "bool": true,
  "array": ["a", "b", "c"],
  "sequence": @[1, 2, 3],
  "table": {
    "key": "value"
  }.toTable()}

test "print":
  shoDbg("debug")
  shoDbg("debug", data = data)

  shoMsg("message")
  shoMsg("message", data = data)

  shoExc(newException(KeyError, "error"))
  shoExc(newException(KeyError, "error"), data = data)

test "debug":
  SHO_VERBOSE = true

  shoDbg("debug")
  shoDbg("debug", data = data)

  shoMsg("message")
  shoMsg("message", data = data)

  shoExc(newException(KeyError, "error"))
  shoExc(newException(KeyError, "error"), data = data)

test "utc":
  SHO_VERBOSE = true
  SHO_USEUTC = true

  shoDbg("debug")
  shoDbg("debug", data = data)

  shoMsg("message")
  shoMsg("message", data = data)

  shoExc(newException(KeyError, "error"))
  shoExc(newException(KeyError, "error"), data = data)

test "print pretty":
  SHO_PRETTY = true

  shoDbg("debug")
  shoDbg("debug", data = data)

  shoMsg("message")
  shoMsg("message", data = data)

  shoExc(newException(KeyError, "error"))
  shoExc(newException(KeyError, "error"), data = data)

test "debug pretty":
  SHO_PRETTY = true
  SHO_VERBOSE = true

  shoDbg("debug")
  shoDbg("debug", data = data)

  shoMsg("message")
  shoMsg("message", data = data)

  shoExc(newException(KeyError, "error"))
  shoExc(newException(KeyError, "error"), data = data)

test "utc pretty":
  SHO_PRETTY = true
  SHO_VERBOSE = true
  SHO_USEUTC = true

  shoDbg("debug")
  shoDbg("debug", data = data)

  shoMsg("message")
  shoMsg("message", data = data)

  shoExc(newException(KeyError, "error"))
  shoExc(newException(KeyError, "error"), data = data)
