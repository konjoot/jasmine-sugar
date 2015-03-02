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

      # fails
      #
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
