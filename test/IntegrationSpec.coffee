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

  xit 'with dependencies', ->
    context.describe 'outer first', ->
      subject.is func(collection)
      obj.is {one: ->'test'}
      arr.is ['a', 'b', 'c']

      @describe 'middle first', ->
        func.is (coll)-> obj['two'] = coll

        @describe 'inner first', ->
          collection.is [1, 2, 3, 4]

        @describe 'inner second', ->
          collection.is ['one', 'two', 'three']

      @describe 'middle second', ->
        func.is (coll)-> arr.push coll[0]

        @describe 'inner third', ->
          collection.is ['d', 'e', 'f']

        @describe 'inner fourth', ->
          collection.is ['e', 'f', 'j']

    context.describe 'outer second', ->
      subject.is {one: one, two: two}
      arr.is [1, 2]

      @describe 'middle third', ->
        one.is 'one'

        @describe 'inner fifth', ->
          two.is arr[0]

        @describe 'inner sixth', ->
          two.is undefined

      @describe 'middle fourth', ->
        one.is 1

        @describe 'inner seventh', ->
          two.is arr[1]

        @describe 'inner eighth', ->
          two.is true

    JE.run(context)


# # Planning DSL example:
# #
# ## on CoffeeScript
# #
# describe 'TestModule', ->
#   subject.is func.module(modArgs)      # func and modArgs will be defined later

# # subject from outer describe should be accessible in the inner describe,
# # and was defined with `args` and `func` defined in the inner describe

#   describe 'inner one', ->
#     func   .is  -> new TestModule(args) # func == new TestModule('empty')
#     modArgs.are [args]                  # modArgs == ['empty']
#     args   .are 'empty'

#     expected(subject).toBeTruthy()   # subject == (new TestModule('empty')).module(['test'])
#     expected(func).toBeDefined()

#   describe 'inner two', ->
#     func   .is  -> new TestModule(args) # func == new TestModule('another')
#     modArgs.are ['one', 'two']          # modArgs == ['one', 'two']
#     args   .are 'another'

#     expected(subject).toBeTruthy() # subject == (new TestModule('another')).module(['one', 'two'])
#     expected(func).toBeDefined()
# #
# ## on JavaScript
# #
# describe('TestModule', function(){
#   subject.is(func.module(modArgs));      # func and modArgs will be defined later

# # subject from outer describe should be accessible in the inner describe,
# # and was defined with `args` and `func` defined in the inner describe

#   describe('inner one', function(){
#     func.is(function(){ new TestModule(args) }); # func == new TestModule('empty')
#     modArgs.are([args]);                  # modArgs == ['empty']
#     args.are('empty');

#     expected(subject).toBeTruthy();   # subject == (new TestModule('empty')).module(['test'])
#     expected(func).toBeDefined();
#   });

#   describe('inner two', function(){
#     func.is(function(){ new TestModule(args) }); # func == new TestModule('another')
#     modArgs.are(['one', 'two']);          # modArgs == ['one', 'two']
#     args.are('another');

#     expected(subject).toBeTruthy(); # subject == (new TestModule('another')).module(['one', 'two'])
#     expected(func).toBeDefined();
#   });
# });
# #
# # less code && less duplication == Profit!
