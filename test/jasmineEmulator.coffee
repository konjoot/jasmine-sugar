# simple Jasmine emulator

JE = do ->

  befores   = {}
  tests     = {}
  afters    = {}
  describes = {}
  currentDescribe = undefined

  {
    beforeEach: (fn)->
      befores[currentDescribe] ||= []
      befores[currentDescribe].push fn

    afterEach: (fn)->
      afters[currentDescribe] ||= []
      afters[currentDescribe].push fn

    it: (name, fn)->
      tests[currentDescribe] ||= []
      tests[currentDescribe].push fn

    describe: (name, fn)->
      currentDescribe = name
      describes[name] = fn

    run: (context = this)->
      for desc of describes

        describes[desc].call context

        before.call(context) for before in befores[desc]

        test.call(context)   for test in tests[desc]

        after.call(context)  for after in afters[desc]
  }
