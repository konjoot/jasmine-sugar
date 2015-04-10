define 'NewAnalyzer', ['Utils', 'EventMachine'], (u, e)->

  SPECIAL_CHARS =
    quote: "'"
    escape: '\\'
    endOfLine: "\n"
    doubleQuote: '"'
    openParenthesis: '('
    closeParenthesis: ')'

  crntChar = undefined

  # current char status
  quote            =
  escape           =
  resolved         =
  endOfLine        =
  doubleQuote      =
  openParenthesis  =
  closeParenthesis = undefined

  # string position status
  dumped      =
  escaped     =
  inString    =
  inDslParams = undefined
  parentheses = []

  get = (name)-> eval name

  resolve     = -> resolved = true
  unresolve   = -> resolved = undefined

  # resolveWith = (value)-> resolve() and value

  dump = (char)->
    crntChar = char if char?
    dumped += char
    dumped = dumped.substr(1) if dumped.length > 4

  callInChain = ->
    unresolve()
    for arg in arguments
      return if resolved?
      arg() if u(arg).isAFunction()

  escapeTracker = ->
    escaped = u(escape? && !escaped?).trueOr undefined

  charFilter = ->
    for name, char of SPECIAL_CHARS
      value = u(crntChar == char).trueOr undefined
      eval "#{name} = #{value};"
    return resolve() unless crntChar in u(SPECIAL_CHARS).values()

  stringTracker = ->
    resolve() if inString?
    return unless quote? or doubleQuote?
    if resolve() and not escaped?
      switch inString
        when "'"
          inString = undefined if quote?
        when '"'
          inString = undefined if doubleQuote?
        when undefined
          inString = crntChar

  parenthesesTracker = ->
    return if escaped?
    return unless openParenthesis? or closeParenthesis?
    parentheses.push crntChar if openParenthesis?
    parentheses.pop() if closeParenthesis?

  dslTracker = ->
    return if escaped? or inString?
    return inDslParams = undefined if u(parentheses).isEmpty()
    return if inDslParams? and openParenthesis?
    inDslParams = parentheses.length if openParenthesis? and dumped == '.is('
    inDslParams = undefined if closeParenthesis? and parentheses.length == inDslParams

  e('quote').triggers stringTracker
  e('newChar').triggers dump, escapeTracker, charFilter
  e('doubleQuote').triggers stringTracker
  e('openParenthesis').triggers parenthesesTracker, dslTracker
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
      # dump(char)
      # callInChain(
      #   escapeTracker
      #   charFilter
      #   stringTracker
      #   parenthesesTracker
      #   dslTracker
      # )
