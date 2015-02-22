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
      eval "root.describes.#{currentPath.join('.')}.describes[key] = val;"
    else
      root.describes[key] = val

  cleanup = ->
    if currentPath.length? and currentPath.length > 0
      eval "delete root.describes.#{currentPath.join('.')};"

    currentPath.pop()

  callRecursively = (describes)->
    return unless describes?
    for _, desc of describes
      desc.func.call(context)
      runDependencies.call(context, desc)
      cleanup.call(context)

  runDependencies = (desc)->
    return unless desc? or desc.name?
    before.call(context) for before in befores[desc.name]

    test.call(context) for test in tests[desc.name]

    callRecursively desc.describes

    after.call(context) for after in afters[desc.name]

    true

  {
    beforeEach: (fn)->
      console.log 'in beforeEach'
      console.log befores
      befores[currentPath.last()].push fn

    afterEach: (fn)->
      console.log 'afterEach'
      afters[currentPath.last()].push fn

    it: (name, fn)->
      console.log 'it'
      tests[currentPath.last()].push fn

    describe: (name, fn)->
      console.log 'in describe'
      console.log name
      desc = {name: name, describes: {}, func: fn}
      addInCurrentPoint(name, desc)
      currentPath.push name
      befores[name]   = []
      tests[name]     = []
      afters[name]    = []

    run: (env = this)->
      context = env
      callRecursively(root.describes)
  }
