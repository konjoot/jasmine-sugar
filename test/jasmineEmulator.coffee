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

    run: ->
      for desc of describes

        describes[desc].call this

        before.call(this) for before in befores[desc]

        test.call(this)   for test in tests[desc]

        after.call(this)  for after in afters[desc]
  }
