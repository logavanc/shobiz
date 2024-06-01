# shobiz

`nimble install shobiz`

![Github Actions](https://github.com/logavanc/shobiz/workflows/Github%20Actions/badge.svg)

[API reference](https://logavanc.github.io/shobiz)

Simple structured console messages for Nim applications.

## About

`shobiz` is a simple library for outputting structured console messages in Nim applications.
Configuration is done with global variables (there is no need to pass around a logger object), and the API consists of only a few methods.

```nim
import shobiz
import json

SHO_PRETTY = true # These should be set with the
SHO_DEBUG = true  # command line arg parser of your choice.

"Hello, Message!".shoMsg()
"Hello, Debug!".shoDbg(%*{"interesting": 1234}) # This is only shown if SHO_DEBUG is true.

try:
  raise newException(KeyError, "Hello, Error!")
except Exception as err:
  err.shoExc()
```

```json
{
    "timestamp": "2024-05-27T21:57:43.862-07:00",
    "level": "Message",
    "message": "Hello, World!"
}
{
    "timestamp": "2024-05-27T21:57:43.862-07:00",
    "level": "Debug",
    "message": "Hello, Debug!",
    "data": {
        "interesting": 1234
    }
}
{
    "timestamp": "2024-05-27T21:57:43.862-07:00",
    "level": "Error",
    "type": "KeyError",
    "message": "Hello, Error!"
}
```

## Pretty Flag

The `SHO_PRETTY` flag is used to determine if the output should be pretty-printed or not.
If set to `true`, the output will be formatted with newlines and indentation, and is intended for human consumption.
If set to `false`(the default), the output will be a single line of minified JSON, which is great for piping to other programs (like `jq`) or writing to a log file (like `| tee -a log.jsonl`).

## Debug Flag

The `SHO_DEBUG` flag is used to determine if debug messages should be shown or not.
If set to `true`, debug messages will be shown.
If set to `false`(the default), debug messages will be suppressed.
