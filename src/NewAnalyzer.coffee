define 'NewAnalyzer', ['Utils'], (u)->

  SPECIAL_CHARS =
    quote: "'"
    escaped: '\\'
    endOfLine: "\n"
    doubleQuote: '"'
    openParenthesis: '('
    closeParenthesis: ')'

  #private methods and variables
  quote            =
  escaped          =
  crntChar         =
  resolved         =
  endOfLine        =
  doubleQuote      =
  openParenthesis  =
  closeParenthesis = undefined

  get = (name)-> eval name

  resolve   = -> resolved = true
  unresolve = -> resolved = undefined

  callInChain = ->
    for arg in arguments
      return if resolved?
      arg() if u(arg).isAFunction()


  charFilter = ->
    return resolve() unless crntChar in u(SPECIAL_CHARS).values()
    for name, char of SPECIAL_CHARS
      value = u(crntChar == char).trueOr undefined
      eval "#{name} = #{value};"

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
        charFilter)
