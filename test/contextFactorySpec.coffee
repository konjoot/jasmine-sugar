define ['contextFactory'], (ContextFactory) ->
  describe 'ContextFactory', ->
    subject      =
    JasmineStore = undefined

    it 'should be defined', ->
      expect(ContextFactory).toBeDefined()

    it 'should be a function', ->
      expect(ContextFactory).toBeAFunction()

    describe 'returnable DSL object', ->

      beforeEach ->
        Jasmine      = jasmine.createSpyObj('JasmineMock', ['beforeEach', 'afterEach'])
        JasmineStore = jasmine.createSpyObj('JasmineStoreMock', ['set', 'defined'])

        JasmineStore.defined.and.returnValue true
        JasmineStore.instance = Jasmine

        subject = new ContextFactory(null, null, JasmineStore)

      it 'interface', ->
        expect(subject).toHaveProperties ['is', 'defined', 'value']

      describe '#is', ->
        fn             =
        name           =
        store          =
        factory        =
        afterEachArgs1 =
        afterEachArgs2 =
        beforeEachArgs = undefined

        beforeEach ->
          name    = 'collection'
          store   = {}
          factory = new ContextFactory(name, store, JasmineStore)

        xdescribe 'first - plain val', ->

          beforeEach -> factory.is 'something'

        xdescribe 'first - function', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is fn

        xdescribe 'first - plain val, second - function ', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is 'something', fn

        xdescribe 'first - function, second - plain val', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is fn, 'something'
