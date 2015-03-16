define 'NewAnalyzer', ['Utils'], (u)->

  #private methods and variables
  crntChar = undefined # currentChar
  resolved = undefined

  get       = (name)-> eval name
  set       = (name, val)-> eval("#{name} = #{eval(val)};")
  resolve   = -> resolved = true
  unresolve = -> resolved = undefined

  charFilter = ->
    return if resolved?
    resolve() unless crntChar in ['"', "'", '\\', '(', ')']

  (name)->
    # allow access to private methods and variables by name
    if name?
      return prop if u(prop = eval(name)).isAFunction()
      return (val)-> (arguments.length == 0 && get(name)) || set(name, val)

    (crntChar)->
      # console.log resolved
      # charFilter()
