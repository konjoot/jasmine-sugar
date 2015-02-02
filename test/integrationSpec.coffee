define ['main'], (JasmineSugar) ->
  fdescribe 'integration tests with JasmineEmulator(JE)', ->
    context = undefined

    beforeEach ->
      Jasmine = getEnv: -> JE
      context = jasmine: Jasmine

      JasmineSugar.setup(context)

    it 'without dependencies', ->
      context.describe 'test', ->

        another   .is 'something else'
        collection.is 'something'
        callee    .is -> 'test func'
        obj       .is {one: 'one', two: ->('dead end')}
        array     .is ['one', 'two', 3]
        int       .is 2
        bool      .is true

        @it -> # using JasmineSugar it method )
          # jasmine it context
          expect(collection).toBeDefined()
          expect(collection).toEqual 'something'
          expect(another).toBeDefined()
          expect(another).toEqual 'something else'
          expect(callee).toBeDefined()
          expect(callee).toBeAFunction()
          expect(callee).toMatchSource 'test func'
          expect(obj).toBeDefined()
          expect(obj).toBeAnObject()
          expect(obj).toHaveProperties ['one', 'two']
          expect(obj.one).toBeAString()
          expect(obj.one).toBe 'one'
          expect(obj.two).toBeAFunction()
          expect(obj.two).toMatchSource 'dead end'
          expect(array).toBeDefined()
          expect(array).toEqual ['one', 'two', 3]
          expect(int).toBeDefined()
          expect(int).toBe 2
          expect(bool).toBeDefined()
          expect(bool).toBeTruthy()


        @it 'anoter one', -> # using JasmineSugar it method )
          # jasmine it context
          expect(collection).toBeDefined()
          expect(collection).toEqual 'something'
          expect(another).toBeDefined()
          expect(another).toEqual 'something else'
          expect(callee).toBeDefined()
          expect(callee).toBeAFunction()
          expect(callee).toMatchSource 'test func'
          expect(obj).toBeDefined()
          expect(obj).toBeAnObject()
          expect(obj).toHaveProperties ['one', 'two']
          expect(obj.one).toBeAString()
          expect(obj.one).toBe 'one'
          expect(obj.two).toBeAFunction()
          expect(obj.two).toMatchSource 'dead end'
          expect(array).toBeDefined()
          expect(array).toEqual ['one', 'two', 3]
          expect(int).toBeDefined()
          expect(int).toBe 2
          expect(bool).toBeDefined()
          expect(bool).toBeTruthy()


        # jasmine describe context
        expect(collection?).toBeTruthy()
        expect(collection).toHaveProperties ['is']
        expect(collection.is).toBeAFunction()
        expect(another?).toBeTruthy()
        expect(another).toHaveProperties ['is']
        expect(another.is).toBeAFunction()
        expect(callee?).toBeTruthy()
        expect(callee).toHaveProperties ['is']
        expect(callee.is).toBeAFunction()
        expect(obj?).toBeTruthy()
        expect(obj).toHaveProperties ['is']
        expect(obj.is).toBeAFunction()
        expect(array?).toBeTruthy()
        expect(array).toHaveProperties ['is']
        expect(array.is).toBeAFunction()
        expect(int?).toBeTruthy()
        expect(int).toHaveProperties ['is']
        expect(int.is).toBeAFunction()
        expect(bool?).toBeTruthy()
        expect(bool).toHaveProperties ['is']
        expect(bool.is).toBeAFunction()

      # outer context before tests run
      expect(collection?).toBeFalsy()
      expect(another?).toBeFalsy()
      expect(callee?).toBeFalsy()
      expect(obj?).toBeFalsy()
      expect(array?).toBeFalsy()
      expect(int?).toBeFalsy()
      expect(bool?).toBeFalsy()

      JE.run(context)

      # outer context after tests run
      expect(collection?).toBeFalsy()
      expect(another?).toBeFalsy()
      expect(callee?).toBeFalsy()
      expect(obj?).toBeFalsy()
      expect(array?).toBeFalsy()
      expect(int?).toBeFalsy()
      expect(bool?).toBeFalsy()

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