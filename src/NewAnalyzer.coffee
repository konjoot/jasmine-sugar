define 'NewAnalyzer', ['Utils', 'EventMachine'], (u, e)->

  SPECIAL_CHARS =
    quote: "'"
    escape: '\\'
    endOfLine: "\n"
    doubleQuote: '"'
    openParenthesis: '('
    closeParenthesis: ')'

  # string position status
  dumped      =
  escaped     =
  inString    =
  inDslParams = undefined
  parentheses = []

  get = (name)-> eval name

  dump = (char)->
    dumped += char
    dumped = dumped.substr(1) if dumped.length > 4

  escapeTracker = (char)->
    return escaped = undefined if escaped?
    escaped = true if char == SPECIAL_CHARS.escape

  charFilter = (char)->
    for name, ch of SPECIAL_CHARS when ch == char
      return e(name).emitWith(ch) if char != SPECIAL_CHARS.escape and not escaped?
      e('escape').emitWith(ch)

  stringTracker = (char)->
    return inString = undefined if inString == char
    inString = char

  parenthesesTracker = (char)->
    if char == SPECIAL_CHARS.openParenthesis
      parentheses.push char
      e('dslMatched').emitWith(char) if dumped == '.is('
    parentheses.pop() if char == SPECIAL_CHARS.closeParenthesis

  dslTracker = (char)->
    return inDslParams = undefined if u(parentheses).isEmpty()
    return if inDslParams? and char == SPECIAL_CHARS.openParenthesis
    inDslParams = parentheses.length if char == SPECIAL_CHARS.openParenthesis and dumped == '.is('
    inDslParams = undefined if char == SPECIAL_CHARS.closeParenthesis and parentheses.length == inDslParams

  e('quote').triggers stringTracker
  e('escape').triggers escapeTracker
  e('newChar').triggers dump, charFilter
  e('dslMatched').triggers dslTracker
  e('doubleQuote').triggers stringTracker
  e('openParenthesis').triggers parenthesesTracker
  e('closeParenthesis').triggers parenthesesTracker, dslTracker

  (name, value)->
    # ability to redefine private functions, and variables
    if name? && arguments.length > 1
      return eval("#{name} = #{eval(value)};") unless value?
      # return eval("#{name} = value;") if u(value).isAFunction()
      return eval("#{name} = value;")

    # allow access to private methods and variables by name
    if name?
      return prop if u(prop = eval(name)).isAFunction()
      return -> get(name)

    (char)-> e('newChar').emitWith char
