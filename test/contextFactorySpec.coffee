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
        expect(subject).toHaveProperties ['is']

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
          beforeEachArgs = /return eval\.call\(this, "var " \+ prop \+ " = '" \+ Store\[prop\] \+ "';"\);/
          afterEachArgs1 = /delete Store\[prop\];/
          afterEachArgs2 = /return eval\.call\(this, "delete " \+ prop \+ ";"\);/

        describe 'first - plain val', ->

          beforeEach -> factory.is 'something'

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign proper value to key in store', ->
            expect(store[name]).toEqual 'something'

          it 'should call jasmine\'s beforeEach method', ->
            expect(JasmineStore.instance.beforeEach).toHaveBeenCalled()
            expect(JasmineStore.instance.beforeEach.calls.count()).toBe 1
            expect(JasmineStore.instance.beforeEach.calls.argsFor(0)).toMatch beforeEachArgs

          it 'should call jasmine\'s afterEach method', ->
            expect(JasmineStore.instance.afterEach).toHaveBeenCalled()
            expect(JasmineStore.instance.afterEach.calls.count()).toBe 1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs2

        describe 'first - function', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is fn

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign function to key in store', ->
            expect(store[name]).toBe fn

          it 'should call jasmine\'s beforeEach method', ->
            expect(JasmineStore.instance.beforeEach).toHaveBeenCalled()
            expect(JasmineStore.instance.beforeEach.calls.count()).toBe 1
            expect(JasmineStore.instance.beforeEach.calls.argsFor(0)).toMatch beforeEachArgs

          it 'should call jasmine\'s afterEach method', ->
            expect(JasmineStore.instance.afterEach).toHaveBeenCalled()
            expect(JasmineStore.instance.afterEach.calls.count()).toBe 1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs2

        describe 'first - plain val, second - function ', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is 'something', fn

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign proper value to key in store', ->
            expect(store[name]).toEqual 'something'

          it 'should call jasmine\'s beforeEach method', ->
            expect(JasmineStore.instance.beforeEach).toHaveBeenCalled()
            expect(JasmineStore.instance.beforeEach.calls.count()).toBe 1
            expect(JasmineStore.instance.beforeEach.calls.argsFor(0)).toMatch beforeEachArgs

          it 'should call jasmine\'s afterEach method', ->
            expect(JasmineStore.instance.afterEach).toHaveBeenCalled()
            expect(JasmineStore.instance.afterEach.calls.count()).toBe 1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs2

        describe 'first - function, second - plain val', ->

          beforeEach ->
            fn = -> 'function result'
            factory.is fn, 'something'

          it 'should add new key to store', ->
            expect(store).toHaveProperties [name]

          it 'should assign function to key in store', ->
            expect(store[name]).toBe fn

          it 'should call jasmine\'s beforeEach method', ->
            expect(JasmineStore.instance.beforeEach).toHaveBeenCalled()
            expect(JasmineStore.instance.beforeEach.calls.count()).toBe 1
            expect(JasmineStore.instance.beforeEach.calls.argsFor(0)).toMatch beforeEachArgs

          it 'should call jasmine\'s afterEach method', ->
            expect(JasmineStore.instance.afterEach).toHaveBeenCalled()
            expect(JasmineStore.instance.afterEach.calls.count()).toBe 1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs1
            expect(JasmineStore.instance.afterEach.calls.argsFor(0)).toMatch afterEachArgs2
