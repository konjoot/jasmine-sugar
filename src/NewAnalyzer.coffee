define 'NewAnalyzer', ['Utils'], (u)->

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
  escaped     =
  inString    = undefined

  get = (name)-> eval name

  resolve     = -> resolved = true
  unresolve   = -> resolved = undefined

  resolveWith = (value)-> resolve() and value

  callInChain = ->
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
    return if escaped?
    return unless quote? or doubleQuote?
    switch inString
      when "'"
        inString = resolveWith(undefined) if quote?
      when '"'
        inString = resolveWith(undefined) if doubleQuote?
      when undefined
        inString = resolveWith(crntChar)


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

    (char)->
      crntChar = char
      callInChain(
        escapeTracker
        charFilter
        stringTracker)
