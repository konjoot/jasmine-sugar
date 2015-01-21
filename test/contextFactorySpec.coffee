define ['contextFactory', 'utils'], (ContextFactory, u) ->
  describe 'ContextFactory', ->
    it 'should be defined', ->
      expect(ContextFactory).toBeDefined()

    it 'should be a function', ->
      expect(ContextFactory).toBeAFunction()

    describe 'returnable DSL object', ->
      subject = undefined

      beforeEach ->
        subject = new ContextFactory()

      it 'interface', ->
        expect(u(subject).keys()).toEqual ['is']

      describe '#is', ->
        fn       =
        name     =
        store    =
        factory  = undefined

        beforeEach ->
          name    = 'collection'
          store   = {}
          factory = new ContextFactory(name, store)

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
