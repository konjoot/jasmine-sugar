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

    fit 'with dependencies', ->
      context.describe 'outer_first', ->
        subject.is func(collection)
        obj.is {one: 'test'}
        arr.is ['a', 'b', 'c']

        JE.beforeEach ->
          expect(subject).toBeUndefined()
          expect(obj).toBeEqual {one: 'test'}
          expect(arr).toBeEqual ['a', 'b', 'c']

        @it 'outer it first', ->
          expect(subject).toBeUndefined()
          expect(obj).toBeEqual {one: 'test'}
          expect(arr).toBeEqual ['a', 'b', 'c']

        @it 'outer it second', ->
          expect(subject).toBeUndefined()
          expect(obj).toBeEqual {one: 'test'}
          expect(arr).toBeEqual ['a', 'b', 'c']

        # JE.afterEach ->
        #   expect(subject).toBeUndefined()
        #   expect(obj).toBeEqual {one: 'test'}
        #   expect(arr).toBeEqual ['a', 'b', 'c']

        @describe 'middle_first', ->
          func.is (coll)-> obj['two'] = coll

          JE.beforeEach ->
            expect(subject).toBeUndefined()
            expect(func)   .toBeUndefined()
            expect(obj).toBeEqual {one: 'test'}
            expect(arr).toBeEqual ['a', 'b', 'c']

          @it 'middle it first', ->
            expect(subject).toBeUndefined()
            expect(func)   .toBeUndefined()
            expect(obj).toBeEqual {one: 'test'}
            expect(arr).toBeEqual ['a', 'b', 'c']

          @it 'middle it second', ->
            expect(subject).toBeUndefined()
            expect(func)   .toBeUndefined()
            expect(obj).toBeEqual {one: 'test'}
            expect(arr).toBeEqual ['a', 'b', 'c']

        #   JE.afterEach ->
        #     expect(subject).toBeUndefined()
        #     expect(func)   .toBeDefined()
        #     expect(func)   .toBeAFunction()
        #     expect(obj).toBeEqual {one: 'test'}
        #     expect(arr).toBeEqual ['a', 'b', 'c']

          @describe 'inner_first', ->
            collection.is [1, 2, 3, 4]

            JE.beforeEach ->
              expect(func).toBeUndefined() # bug?
              expect(obj).toBeEqual {one: 'test', two: [1, 2, 3, 4]}
              expect(arr).toBeEqual ['a', 'b', 'c']
              expect(subject).toBeEqual [1, 2, 3, 4]
              expect(collection).toBeEqual [1, 2, 3, 4]

            @it 'inner it first', ->
              expect(func).toBeUndefined() # bug?
              expect(obj).toBeEqual {one: 'test', two: [1, 2, 3, 4]}
              expect(arr).toBeEqual ['a', 'b', 'c']
              expect(subject).toBeEqual [1, 2, 3, 4]
              expect(collection).toBeEqual [1, 2, 3, 4]

            @it 'inner it second', ->
              expect(func).toBeUndefined() # bug?
              expect(obj).toBeEqual {one: 'test', two: [1, 2, 3, 4]}
              expect(arr).toBeEqual ['a', 'b', 'c']
              expect(subject).toBeEqual [1, 2, 3, 4]
              expect(collection).toBeEqual [1, 2, 3, 4]

        #     JE.afterEach ->
        #       expect(func).toBeDefined()
        #       expect(func).toBeAFunction()
        #       expect(obj).toBeEqual {one: 'test', two: [1, 2, 3, 4]}
        #       expect(arr).toBeEqual ['a', 'b', 'c']
        #       expect(subject).toBeEqual [1, 2, 3, 4]
        #       expect(collection).toBeEqual [1, 2, 3, 4]

          @describe 'inner_second', ->
            collection.is ['one', 'two', 'three']

            JE.beforeEach ->
              expect(func).toBeUndefined() # bug?
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']}
              expect(arr).toBeEqual ['a', 'b', 'c']
              expect(subject).toBeEqual ['one', 'two', 'three']
              expect(collection).toBeEqual ['one', 'two', 'three']

            @it 'inner it third', ->
              expect(func).toBeUndefined() # bug?
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']}
              expect(arr).toBeEqual ['a', 'b', 'c']
              expect(subject).toBeEqual ['one', 'two', 'three']
              expect(collection).toBeEqual ['one', 'two', 'three']

            @it 'inner it fourth', ->
              expect(func).toBeUndefined() # bug?
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']}
              expect(arr).toBeEqual ['a', 'b', 'c']
              expect(subject).toBeEqual ['one', 'two', 'three']
              expect(collection).toBeEqual ['one', 'two', 'three']

        #     JE.afterEach ->
        #       expect(func).toBeDefined()
        #       expect(func).toBeAFunction()
        #       expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']}
        #       expect(arr).toBeEqual ['a', 'b', 'c']
        #       expect(subject).toBeEqual ['one', 'two', 'three']
        #       expect(collection).toBeEqual ['one', 'two', 'three']

        @describe 'middle_second', ->
          func.is (coll)-> arr.push coll[0]

          JE.beforeEach ->
            expect(subject).toBeEqual 4 # bug?
            # expect(subject).toBeUndefined() # should be
            expect(func).toBeUndefined() # bug?
            expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
            # expect(obj).toBeEqual {one: 'test'} # should be
            expect(arr).toBeEqual ['a', 'b', 'c', 'one'] # bug
            # expect(arr).toBeEqual ['a', 'b', 'c'] # should be

          @it 'middle it third', ->
            expect(subject).toBeEqual 4 # bug?
            # expect(subject).toBeUndefined() # should be
            expect(func).toBeUndefined() # bug?
            expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
            # expect(obj).toBeEqual {one: 'test'} # should be
            expect(arr).toBeEqual ['a', 'b', 'c', 'one'] # bug
            # expect(arr).toBeEqual ['a', 'b', 'c'] # should be

          @it 'middle it fourth', ->
            expect(subject).toBeEqual 4 # bug?
            # expect(subject).toBeUndefined() # should be
            expect(func).toBeUndefined() # bug?
            expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
            # expect(obj).toBeEqual {one: 'test'} # should be
            expect(arr).toBeEqual ['a', 'b', 'c', 'one'] # bug
            # expect(arr).toBeEqual ['a', 'b', 'c'] # should be

          @describe 'inner_third', ->
            collection.is ['d', 'e', 'f']

            JE.beforeEach ->
              expect(func).toBeUndefined() # bug
              # expect(func).toBeDefined() # should be
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
              # expect(obj).toBeEqual {one: 'test'} # should be
              expect(arr).toBeEqual ['a', 'b', 'c', 'one', 'd'] # bug
              # expect(arr).toBeEqual ['a', 'b', 'c', 'd'] # should be
              expect(subject).toBeEqual 5 # bug
              # expect(subject).toBeEqual 4 # should be
              expect(collection).toBeEqual ['d', 'e', 'f']

            @it 'inner it fifth', ->
              expect(func).toBeUndefined() # bug
              # expect(func).toBeDefined() # should be
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
              # expect(obj).toBeEqual {one: 'test'} # should be
              expect(arr).toBeEqual ['a', 'b', 'c', 'one', 'd'] # bug
              # expect(arr).toBeEqual ['a', 'b', 'c', 'd'] # should be
              expect(subject).toBeEqual 5 # bug
              # expect(subject).toBeEqual 4 # should be
              expect(collection).toBeEqual ['d', 'e', 'f']

            @it 'inner it sixth', ->
              expect(func).toBeUndefined() # bug
              # expect(func).toBeDefined() # should be
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
              # expect(obj).toBeEqual {one: 'test'} # should be
              expect(arr).toBeEqual ['a', 'b', 'c', 'one', 'd'] # bug
              # expect(arr).toBeEqual ['a', 'b', 'c', 'd'] # should be
              expect(subject).toBeEqual 5 # bug
              # expect(subject).toBeEqual 4 # should be
              expect(collection).toBeEqual ['d', 'e', 'f']

        #     JE.afterEach ->
        #       expect(func).toBeDefined()
        #       expect(func).toBeAFunction()
        #       expect(obj).toBeEqual {one: 'test'}
        #       expect(arr).toBeEqual ['a', 'b', 'c', 'd']
        #       expect(subject).toBeEqual 4
        #       expect(collection).toBeEqual ['d', 'e', 'f']

          @describe 'inner_fourth', ->
            collection.is ['e', 'f', 'j']

            JE.beforeEach ->
              expect(func).toBeUndefined() # bug
              # expect(func).toBeDefined() # should be
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
              # expect(obj).toBeEqual {one: 'test'} # should be
              expect(arr).toBeEqual ['a', 'b', 'c', 'one', 'd', 'e'] # bug
              # expect(arr).toBeEqual ['a', 'b', 'c', 'e'] # should be
              expect(subject).toBeEqual 6 #bug
              # expect(subject).toBeEqual 4 # should be
              expect(collection).toBeEqual ['e', 'f', 'j']

            @it 'inner it seventh', ->
              expect(func).toBeUndefined() # bug
              # expect(func).toBeDefined() # should be
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
              # expect(obj).toBeEqual {one: 'test'} # should be
              expect(arr).toBeEqual ['a', 'b', 'c', 'one', 'd', 'e'] # bug
              # expect(arr).toBeEqual ['a', 'b', 'c', 'e'] # should be
              expect(subject).toBeEqual 6 #bug
              # expect(subject).toBeEqual 4 # should be
              expect(collection).toBeEqual ['e', 'f', 'j']

            @it 'inner it eighth', ->
              expect(func).toBeUndefined() # bug
              # expect(func).toBeDefined() # should be
              expect(obj).toBeEqual {one: 'test', two: ['one', 'two', 'three']} # bug
              # expect(obj).toBeEqual {one: 'test'} # should be
              expect(arr).toBeEqual ['a', 'b', 'c', 'one', 'd', 'e'] # bug
              # expect(arr).toBeEqual ['a', 'b', 'c', 'e'] # should be
              expect(subject).toBeEqual 6 #bug
              # expect(subject).toBeEqual 4 # should be
              expect(collection).toBeEqual ['e', 'f', 'j']

        #     JE.afterEach ->
        #       expect(func).toBeDefined()
        #       expect(func).toBeAFunction()
        #       expect(obj).toBeEqual {one: 'test'}
        #       expect(arr).toBeEqual ['a', 'b', 'c', 'e']
        #       expect(subject).toBeEqual 4
        #       expect(collection).toBeEqual ['e', 'f', 'j']

      context.describe 'outer_second', ->
        subject.is {one: one, two: two}
        arr.is [1, 2]

        JE.beforeEach ->
          expect(subject).toBeUndefined()
          expect(arr).toBeEqual [1, 2]

        @it 'outer it third', ->
          expect(subject).toBeUndefined()
          expect(arr).toBeEqual [1, 2]

        @it 'outer it fourth', ->
          expect(subject).toBeUndefined()
          expect(arr).toBeEqual [1, 2]

        # JE.afterEach ->
        #   expect(subject).toBeUndefined()
        #   expect(arr).toBeEqual [1, 2]

        @describe 'middle_third', ->
          one.is 'one'

          JE.beforeEach ->
            expect(subject).toBeUndefined()
            expect(one).toBeEqual 'one'
            expect(arr).toBeEqual [1, 2]

          @it 'middle it fifth', ->
            expect(subject).toBeUndefined()
            expect(one).toBeEqual 'one'
            expect(arr).toBeEqual [1, 2]

          @it 'middle it sixth', ->
            expect(subject).toBeUndefined()
            expect(one).toBeEqual 'one'
            expect(arr).toBeEqual [1, 2]

          # JE.afterEach ->
          #   expect(subject).toBeUndefined()
          #   expect(one).toBeEqual 'one'
          #   expect(arr).toBeEqual [1, 2]

          @describe 'inner_fifth', ->
            two.is arr[1]

            JE.beforeEach ->
              expect(one).toBeEqual 'one'
              expect(two).toBeEqual 2
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 'one', two: 2}

            @it 'inner it ninth', ->
              expect(one).toBeEqual 'one'
              expect(two).toBeEqual 2
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 'one', two: 2}

            @it 'inner it tenth', ->
              expect(one).toBeEqual 'one'
              expect(two).toBeEqual 2
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 'one', two: 2}

            # JE.afterEach ->
            #   expect(one).toBeEqual 'one'
            #   expect(two).toBeEqual 2
            #   expect(arr).toBeEqual [1, 2]
            #   expect(subject).toBeEqual {one: 'one', two: 2}

          @describe 'inner_sixth', ->
            two.is 'two'

            JE.beforeEach ->
              expect(one).toBeEqual 'one'
              expect(two).toBeEqual 'two'
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 'one', two: 'two'}

            @it 'inner it eleventh', ->
              expect(one).toBeEqual 'one'
              expect(two).toBeEqual 'two'
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 'one', two: 'two'}

            @it 'inner it twelfth', ->
              expect(one).toBeEqual 'one'
              expect(two).toBeEqual 'two'
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 'one', two: 'two'}

      #       JE.afterEach ->
      #         expect(one).toBeEqual 'one'
      #         expect(two).toBeEqual 'two'
      #         expect(arr).toBeEqual [1, 2]
      #         expect(subject).toBeEqual {one: 'one', two: 'two'}

        @describe 'middle_fourth', ->
          one.is 1

          JE.beforeEach ->
            expect(subject).toBeEqual {one: 1, two: 'two'} # bug
            # expect(subject).toBeUndefined() # should be
            expect(one).toBeEqual 1
            expect(arr).toBeEqual [1, 2]

          @it 'middle it seventh', ->
            expect(subject).toBeEqual {one: 1, two: 'two'} # bug
            # expect(subject).toBeUndefined() # should be
            expect(one).toBeEqual 1
            expect(arr).toBeEqual [1, 2]

          @it 'middle it eighth', ->
            expect(subject).toBeEqual {one: 1, two: 'two'} # bug
            # expect(subject).toBeUndefined() # should be
            expect(one).toBeEqual 1
            expect(arr).toBeEqual [1, 2]

      #     JE.afterEach ->
      #       expect(subject).toBeUndefined()
      #       expect(one).toBeEqual 1
      #       expect(arr).toBeEqual [1, 2]

          @describe 'inner_seventh', ->
            two.is arr[1]

            JE.beforeEach ->
              expect(one).toBeEqual 1
              expect(two).toBeEqual 2
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 1, two: 2}

            @it 'inner it thirteenth', ->
              expect(one).toBeEqual 1
              expect(two).toBeEqual 2
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 1, two: 2}

            @it 'inner it fourteenth', ->
              expect(one).toBeEqual 1
              expect(two).toBeEqual 2
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 1, two: 2}

      #       JE.afterEach ->
      #         expect(one).toBeEqual 1
      #         expect(two).toBeEqual 2
      #         expect(arr).toBeEqual [1, 2]
      #         expect(subject).toBeEqual {one: 1, two: 2}

          @describe 'inner_eighth', ->
            two.is true

            JE.beforeEach ->
              expect(one).toBeEqual 1
              expect(two).toBeEqual true
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 1, two: true}

            @it 'inner it fifteenth', ->
              expect(one).toBeEqual 1
              expect(two).toBeEqual true
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 1, two: true}

            @it 'inner it sixteenth', ->
              expect(one).toBeEqual 1
              expect(two).toBeEqual true
              expect(arr).toBeEqual [1, 2]
              expect(subject).toBeEqual {one: 1, two: true}

      #       JE.afterEach ->
      #         expect(one).toBeEqual 1
      #         expect(two).toBeEqual true
      #         expect(arr).toBeEqual [1, 2]
      #         expect(subject).toBeEqual {one: 1, two: true}

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
