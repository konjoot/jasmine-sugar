define ['contextFactory'], (ContextFactory) ->
  describe 'ContextFactory', ->
    it 'should be defined', ->
      expect(ContextFactory).toBeDefined()

    it 'should be a function', ->
      expect(ContextFactory).toBeAFunction()

    describe 'returnable DSL object', ->
      subject      =
      JasmineStore = undefined

      beforeEach ->
        Jasmine      = jasmine.createSpyObj('JasmineMock', ['beforeEach', 'afterEach'])
        JasmineStore = jasmine.createSpyObj('JasmineStoreMock', ['set', 'defined'])

        JasmineStore.defined.and.returnValue true
        JasmineStore.instance = Jasmine

        subject = new ContextFactory(null, null, JasmineStore)

      it 'interface', ->
        expect(subject).toHaveProperties ['is']

      describe '#is', ->
        fn       =
        name     =
        store    =
        factory  = undefined

        beforeEach ->
          name    = 'collection'
          store   = {}
          factory = new ContextFactory(name, store, JasmineStore)

        describe 'first - plain val', ->

          beforeEach -> factory.is 'something'

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign proper value to key in store', ->
            expect(store[name]).toEqual 'something'

        describe 'first - function', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is fn

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign function to key in store', ->
            expect(store[name]).toBe fn

        describe 'first - plain val, second - function ', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is 'something', fn

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign proper value to key in store', ->
            expect(store[name]).toEqual 'something'

        describe 'first - function, second - plain val', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is fn, 'something'

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign function to key in store', ->
            expect(store[name]).toBe fn
