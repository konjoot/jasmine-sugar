define 'NewAnalyzer', ['Utils'], (u)->

  #private methods and variables
  crntChar = undefined # currentChar
  resolved = undefined

  get = (name)-> eval name

  resolve   = -> resolved = true
  unresolve = -> resolved = undefined


  charFilter = ->
    return if resolved?
    resolve() unless crntChar in ['"', "'", '\\', '(', ')']

  (name, value)->
    # ability to redefine private functions, and variables
    if name? && arguments.length > 1
      return eval("#{name} = #{eval(value)};") unless value?
      return eval("#{name} = value;") if u(value).isAFunction()
      return eval("#{name} = value;")

    # allow access to private methods and variables by name
    if name?
      return prop if u(prop = eval(name)).isAFunction()
      return -> get(name)

    (char)->
      crntChar = char
      charFilter()
