define ['callbackWrapper'], (CallbackWrapper)->
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
