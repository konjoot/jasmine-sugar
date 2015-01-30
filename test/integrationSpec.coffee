define ['main'], (JasmineSugar) ->
  describe 'integration tests with JasmineEmulator(JE)', ->
    context = undefined

    beforeEach ->
      Jasmine = getEnv: -> JE
      context = jasmine: Jasmine

      JasmineSugar.setup(context)

    it 'without dependencies', ->
      context.describe 'test', ->

        another   .is 'something else'
        collection.is 'something'

        @it -> # using JasmineSugar it method )
          # jasmine it context
          expect(collection).toBeDefined()
          expect(collection).toEqual 'something'
          expect(another).toBeDefined()
          expect(another).toEqual 'something else'

        @it 'anoter one', -> # using JasmineSugar it method )
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

    xit 'without dependencies when collide with outer variables'

    xit 'without dependencies when collide with context methods names'

    xit 'with dependencies in latter describe'

    xit 'with dependencies in parent and latter describes'

# todo: specs that spies beforeEach and afterEach calls - in callbackFactorySpec
# todo: specs that checks Store changes between beforeEach and afterEach calls - in callbackFactorySpec
#   for that case may be suitable to use in callbackFactorySpec JE
#   and in JE implement methods which allows to separately run befores, tests and afters
# todo: specs with multiple it calls in one describe

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