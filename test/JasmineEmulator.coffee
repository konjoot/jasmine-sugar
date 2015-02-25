# simple Jasmine emulator

JE = do ->

  befores   = {}
  tests     = {}
  afters    = {}
  context   = {}
  root = {describes: {}}
  currentPath = []
  Array::last = -> this[@length - 1]
  currentDescribe = undefined

  addInCurrentPoint = (key, val)->
    if currentPath.length? and currentPath.length > 0
      eval "root.describes.#{currentPath.join('.describes.')}.describes[key] = val;"
    else
      root.describes[key] = val

  cleanup = ->
    if currentPath.length? and currentPath.length > 0
      eval "delete root.describes.#{currentPath.join('.describes.')};"

    currentPath.pop()

  callRecursively = (describes)->
    return unless describes?
    for _, desc of describes
      currentPath.push desc.name
      desc.func.call(context)
      runDependencies.call(context, desc)
      cleanup.call(context)

  runDependencies = (desc)->
    return unless desc? or desc.name?

    for test in tests[desc.name]
      before.call(context) for before in befores[desc.name]
      test.call(context)
      after.call(context) for after in afters[desc.name].slice().reverse()

    for name, _ of desc.describes
      befores[name] = befores[desc.name].concat befores[name]
      afters[name] = afters[desc.name].concat afters[name]

    callRecursively desc.describes

  {
    beforeEach: (fn)->
      befores[currentPath.last()].push fn

    afterEach: (fn)->
      afters[currentPath.last()].push fn

    it: (name, fn)->
      tests[currentPath.last()].push fn

    describe: (name, fn)->
      desc = {name: name, describes: {}, func: fn}
      addInCurrentPoint(name, desc)
      # currentPath.push name
      befores[name]   = []
      tests[name]     = []
      afters[name]    = []

    run: (env = this)->
      context = env
      callRecursively(root.describes)
  }
