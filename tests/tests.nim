import unittest
import json

import shobiz

test "print":
  shoDbg("debug")
  shoMsg("message")
  shoErr(newException(KeyError, "error"))

test "debug":
  SHO_VERBOSE = true

  shoDbg("debug")
  shoMsg("message")
  shoErr(newException(KeyError, "error"))

test "utc":
  SHO_VERBOSE = true
  SHO_USEUTC = true

  shoDbg("debug")
  shoMsg("message")
  shoErr(newException(KeyError, "error"))

test "data":
  shoDbg("debug", data = %{"a": %1, "b": %2})
  shoMsg("message", data = %{"a": %1, "b": %2, "better": %true})
  shoErr(newException(KeyError, "error"), data = %{"a": %1, "b": %2})
