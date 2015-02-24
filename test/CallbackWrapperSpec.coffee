define ['CallbackWrapper'], (CallbackWrapper)->
  describe 'CallbackWrapper', ->
    it 'should be defined', ->
      expect(CallbackWrapper).toBeDefined()

    it 'should be a function', ->
      expect(CallbackWrapper).toBeAFunction()

    describe 'constructed CallbackWrapper', ->
      subject  = undefined

      beforeEach ->
        subject = new CallbackWrapper()

      it 'interface', ->
        expect(subject).toHaveProperties ['run', 'properties']

      it 'run should be a function', ->
        expect(subject.run).toBeAFunction()

      it 'properties should be a function', ->
        expect(subject.properties).toBeAFunction()

      describe '#properties', ->
        beforeEach ->
          callback = new CallbackWrapper()
          subject  = callback.properties()

        it 'should return an array', ->
          expect(subject).toBeAnArray()

        describe 'no callback', ->
          it 'should return empty array', ->
            expect(subject).toBeEmpty()

        describe 'empty callback', ->
          beforeEach ->
            callback = new CallbackWrapper(->)
            subject  = callback.properties()

          it 'should return empty array', ->
            expect(subject).toBeEmpty()

        describe 'one function in callback', ->
          beforeEach ->
            callback = new CallbackWrapper(-> something.is 'whatever')
            subject  = callback.properties()

          it 'not to be empty', ->
            expect(subject).not.toBeEmpty()

          it 'should return array with "something"', ->
            expect(subject).toEqual ['something']

        describe 'multiple functions in callback', ->
          beforeEach ->
            callback = new CallbackWrapper ->
              something.is 'whatever'
              result.is -> 'empty'
              object.is {one: 'one', two: -> 'dead end'}
              array.is ['one', 2, 'three']

            subject  = callback.properties()

          it 'not to be empty', ->
            expect(subject).not.toBeEmpty()

          it 'should return array with "something" and "result"', ->
            expect(subject).toEqual ['something', 'result', 'object', 'array']

        describe 'abracadabra in context', ->
          beforeEach ->
            callback = new CallbackWrapper ->
              abracadabra

            subject  = callback.properties()

          it 'should return empty array', ->
            expect(subject).toBeEmpty()

        describe 'valid javascript in context', ->
          beforeEach ->
            callback = new CallbackWrapper ->
              [a, b] = [2, 3]
              a + b

            subject  = callback.properties()

          it 'should return empty array', ->
            expect(subject).toBeEmpty()

        describe 'valid javascript and one function in context', ->
          beforeEach ->
            callback = new CallbackWrapper ->
              [a, b] = [2, 3]
              a + b

              something.is 'wrong'

            subject  = callback.properties()

          it 'not to be empty', ->
            expect(subject).not.toBeEmpty()

          it 'should return array with "something"', ->
            expect(subject).toEqual ['something']

      # fails
      #
      describe '#prepareCallback debugging test', ->
        expected = undefined

        describe 'simple string', ->
          beforeEach ->
            callback = ->
              collection.is 'something'

              @it 'test', ->
                expect(collection).toBeEqual 'something'

              @describe 'inner', ->
                another.is 'something else'

                @it 'test2', ->
                  expect(another).toBeEqual 'something else'

            subject = (new CallbackWrapper(callback)).prepareCallback()

          xit 'should wraps .is arguments with function', ->
            expect(subject).toBeEqual expected

      #   describe 'simple function', ->
      #     beforeEach ->
      #       callback = ->
      #         collection.is -> 'something'

      #         @it 'test', ->
      #           expect(collection).toBeEqual 'something'

      #       expected = ->
      #         collection.is -> -> 'something'

      #         @it 'test', ->
      #           expect(collection).toBeEqual 'something'

      #       subject = (new CallbackWrapper(callback)).prepareCallback()

      #     it 'should wraps .is arguments with function', ->
      #       expect(subject).toBeEqual expected

      #   describe 'simple object', ->
      #     beforeEach ->
      #       callback = ->
      #         collection.is {one: 'something', two: -> 'something else'}

      #         @it 'test', ->
      #           expect(collection).toBeEqual 'something'

      #       expected = ->
      #         collection.is -> {one: 'something', two: -> 'something else'}

      #         @it 'test', ->
      #           expect(collection).toBeEqual 'something'

      #       subject = (new CallbackWrapper(callback)).prepareCallback()

      #     it 'should wraps .is arguments with function', ->
      #       expect(subject).toBeEqual expected

      #   describe 'complicated string', ->
      #     beforeEach ->
      #       callback = ->
      #         collection.is 'collection.is("something"); function(){ another.is(\'bad\') }'
      #         another.is 'another.is("something"); //func()()\sdflj-f04 jr0jr0 jefjojfj"""""\'\\\'\'\'\'\'\'tion(){ another.is(\'bad\') }'

      #         @it 'test', ->
      #           expect(collection).toBeEqual 'something'

      #       expected = ->
      #         collection.is -> 'collection.is("something"); function(){ another.is(\'bad\') }'
      #         another.is -> 'another.is("something"); //func()()\sdflj-f04 jr0jr0 jefjojfj"""""\'\\\'\'\'\'\'\'tion(){ another.is(\'bad\') }'

      #         @it 'test', ->
      #           expect(collection).toBeEqual 'something'

      #       subject = (new CallbackWrapper(callback)).prepareCallback()

      #     it 'should wraps .is arguments with function', ->
      #       expect(subject).toBeEqual expected

      #   describe 'regexp', ->
          # beforeEach ->
          #   callback = ->
          #     collection.is /\n*(\w*)\.is(.|\n*)/g

          #     @it 'test', ->
          #       expect(collection).toBeEqual 'something'

          #   expected = ->
          #     collection.is -> /\n*(\w*)\.is(.|\n*)/g

          #     @it 'test', ->
          #       expect(collection).toBeEqual 'something'

          #   subject = (new CallbackWrapper(callback)).prepareCallback()

          # it 'should wraps .is arguments with function', ->
          #   expect(subject).toBeEqual expected
