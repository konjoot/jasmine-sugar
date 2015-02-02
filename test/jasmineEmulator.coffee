# simple Jasmine emulator

JE = do ->

  befores   = {}
  tests     = {}
  afters    = {}
  describes = {}
  currentDescribe = undefined

  {
    beforeEach: (fn)->
      befores[currentDescribe].push fn

    afterEach: (fn)->
      afters[currentDescribe].push fn

    it: (name, fn)->
      tests[currentDescribe].push fn

    describe: (name, fn)->
      console.log 'in emulator'
      console.log arguments
      currentDescribe = name
      befores[name]   = []
      tests[name]     = []
      afters[name]    = []
      describes[name] = fn

    run: (context = this)->
      for desc of describes

        describes[desc].call context

        before.call(context) for before in befores[desc]

        test.call(context)   for test in tests[desc]

        after.call(context)  for after in afters[desc]
  }
