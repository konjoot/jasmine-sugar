# simple Jasmine emulator

JE = do ->

  befores   = {}
  tests     = {}
  afters    = {}
  root = {describes: {}}
  currentPath = []
  currentPath::last = -> this[@length - 1]
  currentDescribe = undefined

  addInCurrentPoint = (key, val)->
    if currentPath.length? and currentPath.length > 0
      eval "root.#{currentPath.join('.')[key] = val};"
    else
      root.describes[key] = val

  cleanup = ->
    eval "delete root.#{currentPath.join('.')};"
    currentPath.pop()

  {
    beforeEach: (fn)->
      befores[currentPath.last()].push fn

    afterEach: (fn)->
      afters[currentPath.last()].push fn

    it: (name, fn)->
      tests[currentPath.last()].push fn

    describe: (name, fn)->
      currentPath.push name
      befores[name]   = []
      tests[name]     = []
      afters[name]    = []
      addInCurrentPoint(name, {name: name, describes: {}, func: -> (fn() && cleanup())})

    run: (context = this)->
      for _, desc of root.describes

        desc.func.call(context)

        before.call(context)     for before in befores[desc]

        test.call(context)       for test in tests[desc]

        idesc.func.call(context) for _, idesc of desc.describes

        after.call(context)      for after in afters[desc]
  }
