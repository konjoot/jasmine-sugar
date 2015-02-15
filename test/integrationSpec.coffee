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
        callee    .is -> 'test func'
        obj       .is {one: 'one', two: ->('dead end')}
        array     .is ['one', 'two', 3]
        int       .is 2
        bool      .is true

        @it -> # using JasmineSugar it method )
          # jasmine it context
          expect(int)       .toBeEqual 2
          expect(obj)       .toBeEqual {one: 'one', two: ->('dead end')}
          expect(bool)      .toBeEqual true
          expect(array)     .toBeEqual ['one', 'two', 3]
          expect(callee)    .toBeEqual -> 'test func'
          expect(another)   .toBeEqual 'something else'
          expect(collection).toBeEqual 'something'

        @it 'anoter one', -> # using JasmineSugar it method )
          # jasmine it context
          expect(int)       .toBeEqual 2
          expect(obj)       .toBeEqual {one: 'one', two: ->('dead end')}
          expect(bool)      .toBeEqual true
          expect(array)     .toBeEqual ['one', 'two', 3]
          expect(callee)    .toBeEqual -> 'test func'
          expect(another)   .toBeEqual 'something else'
          expect(collection).toBeEqual 'something'

        # jasmine describe context
        expect(_int_)       .toBeADslProvider()
        expect(_obj_)       .toBeADslProvider()
        expect(_bool_)      .toBeADslProvider()
        expect(_array_)     .toBeADslProvider()
        expect(_callee_)    .toBeADslProvider()
        expect(_another_)   .toBeADslProvider()
        expect(_collection_).toBeADslProvider()

      # # outer context before tests run
      expect('int')       .not.toBePresent()
      expect('obj')       .not.toBePresent()
      expect('bool')      .not.toBePresent()
      expect('array')     .not.toBePresent()
      expect('callee')    .not.toBePresent()
      expect('another')   .not.toBePresent()
      expect('collection').not.toBePresent()

      JE.run(context)

      # # outer context after tests run
      expect('int')       .not.toBePresent()
      expect('obj')       .not.toBePresent()
      expect('bool')      .not.toBePresent()
      expect('array')     .not.toBePresent()
      expect('callee')    .not.toBePresent()
      expect('another')   .not.toBePresent()
      expect('collection').not.toBePresent()

    # extend previous test with this cases:
    #   'when collide with outer variables'
    #   'when collide with context methods names'
    #   'multiple describes (inner and parallel)'

    it 'dependencies in one describe part 1', ->
      context.describe 'test', ->
        collection.is 'something else'
        another   .is collection + ' another'

        @it 'one', ->
          expect(another).toBeEqual 'something else another'
          expect(collection).toBeEqual 'something else'

        @it 'two', ->
          expect(collection).toBeEqual 'something else'
          expect(another).toBeEqual 'something else another'

      JE.run(context)

    it 'dependencies in one describe part 2', ->
      context.describe 'test', ->
        another   .is collection + ' another'
        collection.is 'something else'

        @it 'one', ->
          console.log collection
          console.log another
          expect(collection).toBeEqual 'something else'
          expect(another).toBeEqual 'something else another'

        @it 'two', ->
          expect(collection).toBeEqual 'something else'
          expect(another).toBeEqual 'something else another'

      JE.run(context)

    it 'dependencies with inner describe part 1', ->
      context.describe 'test3', ->
        another   .is collection + ' another'
        third     .is 'Third'

        @it 'one', ->
          expect(third).toBeEqual 'Third'
          expect(collection).toBeUndefined()
          expect(another).toBeUndefined()

        @describe 'inner', ->
          collection.is 'something else'

          @it 'two', ->
            console.log another
            expect(third).toBeEqual 'Third'
            expect(collection).toBeEqual 'something else'
            expect(another).toBeEqual 'something else another'

          @it 'three', ->
            expect(third).toBeEqual 'Third'
            expect(collection).toBeEqual 'something else'
            expect(another).toBeEqual 'something else another'

      JE.run(context)


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