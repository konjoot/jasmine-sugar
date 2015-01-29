define ['main'], (JasmineSugar) ->
  fdescribe 'integration tests with JasmineEmulator(JE)', ->
    context                 =
    collectionInIt          =
    collectionInDescribe    =
    collectionOutOfDescribe = undefined

    beforeEach ->
      Jasmine = getEnv: -> JE
      context = jasmine: Jasmine

      JasmineSugar.setup(context)

      context.describe 'test', ->
        collection.is 'something'

        @it -> # using JasmineSugar it method ;)
          collectionInIt = collection
        collectionInDescribe = collection

      collectionOutOfDescribe = collection if collection?

      JE.run(context)

      collectionOutOfTestCase = collection if collection?

    describe 'collection in it block', ->
      it 'should be defined', ->
        expect(collectionInIt).toBeDefined()

      it 'should be eq something', ->
        expect(collectionInIt).toEqual 'something'

    describe 'collection in describe block', ->
      it 'should be defined', ->
        expect(collectionInDescribe).toBeDefined()

      it 'should be DSL object', ->
        expect(collectionInDescribe).toHaveProperties ['is']

    describe 'collection in outer context', ->
      it ''

    it 'with plain type one declaration', ->
      context.describe 'test', ->

        collection.is 'something'

        @it -> # using JasmineSugar it method ;)
          # jasmine it's context
          expect(collection).toBeDefined()
          expect(collection).toEqual 'something'

        # jasmine describe's context
        expect(collection?).toBeTruthy()
        expect(collection).toHaveProperties ['is']

      # outer context before tests run
      expect(collection?).toBeFalsy()

      JE.run(context)

      # outer context after tests run
      expect(collection?).toBeFalsy()

    it 'with plain type multiple declarations', ->
      context.describe 'test', ->

        another   .is 'something else'
        collection.is 'something'

        @it -> # using JasmineSugar it method )
          # jasmine it context
          expect(collection).toBeDefined()
          expect(collection).toEqual 'something'
          expect(another).toBeDefined()
          expect(another).toEqual 'something else'

        # jasmine describe context
        expect(collection?).toBeTruthy()
        expect(collection).toHaveProperties ['is']
        expect(another?).toBeTruthy()
        expect(another).toHaveProperties ['is']

      # outer context before tests run
      expect(collection?).toBeFalsy()
      expect(another?).toBeFalsy()

      JE.run(context)

      # outer context after tests run
      expect(collection?).toBeFalsy()
      expect(another?).toBeFalsy()

    xit 'with plain type multiple declarations when collide with outer variables'

    xit 'with plain type multiple declarations when collide with context methods names'

    xit 'with function one declaration'

    xit 'with function multiple declarations'

    xit 'with function multiple declarations when collide with outer variables'

    xit 'with function multiple declarations when collide with context methods names'

# todo: specs that spies beforeEach and afterEach calls - in callbackFactorySpec
# todo: specs that checks Store changes between beforeEach and afterEach calls - in callbackFactorySpec
#   for that case may be suitable to use in callbackFactorySpec JE
#   and in JE implement methods which allows to separately run befores, tests and afters
# todo: specs with multiple it calls in one describe
# todo: rewrite integration tests:
#   - move JE describe in beforeEach
#   - retrieve needed vars from multiple places in JE's describe
#   - and then test this in it blocks

## Planning DSL example:
#
# describe 'TestModule', ->
#   subject.is func.module(modArgs)      # func and modArgs will be defined later
#
## subject from outer describe should be accessible in the inner describe,
## and was defined with `args` and `func` defined in the inner describe
#
#   describe 'inner one', ->
#     func   .is  -> new TestModule(args) # func == new TestModule('empty')
#     modArgs.are [args]                  # modArgs == ['empty']
#     args   .are 'empty'
#
#     it -> expect(subject).toBeTruthy()   # subject == (new TestModule('empty')).module(['test'])
#     it -> expect(func).toBeDefined()
#
#   describe 'inner two', ->
#     func   .is  -> new TestModule(args) # func == new TestModule('another')
#     modArgs.are ['one', 'two']          # modArgs == ['one', 'two']
#     args   .are 'another'
#
#     it -> expect(subject).toBeTruthy() # subject == (new TestModule('another')).module(['one', 'two'])
#     it -> expect(func).toBeDefined()
#
## less code && less duplication == Profit!