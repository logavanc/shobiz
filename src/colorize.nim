import json
import strutils
import tables
import terminal

var
  SHO_KEY_COLOR* = fgMagenta
  SHO_STRING_COLOR* = fgCyan
  SHO_NUMBER_COLOR* = fgGreen
  SHO_BOOL_COLOR* = fgRed
  SHO_NULL_COLOR* = fgYellow

# Copied from std/json
proc indent(s: var string, i: int) =
  s.add(spaces(i))

# Copied from std/json
proc newIndent(curr, indent: int, ml: bool): int =
  if ml: return curr + indent
  else: return indent

# Copied from std/json
proc nl(s: var string, ml: bool) =
  s.add(if ml: "\n" else: " ")

proc toPrettyColor(
  result: var string,
  node: JsonNode,
  indent = 2,
  ml = true,
  lstArr = false,
  currIndent = 0) =

  case node.kind
  of JObject:
    if lstArr: result.indent(currIndent) # Indentation
    if node.fields.len > 0:
      result.add("{")
      result.nl(ml) # New line
      var i = 0
      for key, val in pairs(node.fields):
        if i > 0:
          result.add(",")
          result.nl(ml) # New Line
        inc i
        # Need to indent more than {
        result.indent(newIndent(currIndent, indent, ml))
        result.add(SHO_KEY_COLOR.ansiForegroundColorCode)
        escapeJson(key, result)
        result.add(ansiResetCode)
        result.add(": ")
        toPrettyColor(result, val, indent, ml, false, newIndent(currIndent, indent, ml))
      result.nl(ml)
      result.indent(currIndent) # indent the same as {
      result.add("}")
    else:
      result.add("{}")
  of JString:
    if lstArr: result.indent(currIndent)
    result.add(SHO_STRING_COLOR.ansiForegroundColorCode)
    toUgly(result, node)
    result.add(ansiResetCode)
  of JInt:
    if lstArr: result.indent(currIndent)
    result.add(SHO_NUMBER_COLOR.ansiForegroundColorCode)
    result.addInt(node.num)
    result.add(ansiResetCode)
  of JFloat:
    if lstArr: result.indent(currIndent)
    result.add(SHO_NUMBER_COLOR.ansiForegroundColorCode)
    result.addFloat(node.fnum)
    result.add(ansiResetCode)
  of JBool:
    if lstArr: result.indent(currIndent)
    result.add(SHO_BOOL_COLOR.ansiForegroundColorCode)
    result.add(if node.bval: "true" else: "false")
    result.add(ansiResetCode)
  of JArray:
    if lstArr: result.indent(currIndent)
    if len(node.elems) != 0:
      result.add("[")
      result.nl(ml)
      for i in 0..len(node.elems)-1:
        if i > 0:
          result.add(",")
          result.nl(ml) # New Line
        toPrettyColor(result, node.elems[i], indent, ml,
            true, newIndent(currIndent, indent, ml))
      result.nl(ml)
      result.indent(currIndent)
      result.add("]")
    else: result.add("[]")
  of JNull:
    if lstArr: result.indent(currIndent)
    result.add(SHO_NULL_COLOR.ansiForegroundColorCode)
    result.add("null")
    result.add(ansiResetCode)

proc prettyColor*(node: JsonNode, indent = 2): string =
  ## Json pretty print with color.
  result = ""
  toPrettyColor(result, node, indent)
