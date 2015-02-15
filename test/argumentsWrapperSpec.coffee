define ['ArgumentsWrapper'], (ArgumentsWrapper) ->
  describe 'ArgumentsWrapper', ->
    subject = undefined

    beforeEach ->
      subject = ArgumentsWrapper

    it 'should be defined', ->
      expect(subject).toBeDefined()

    describe 'Wrapper', ->
      first   =
      second  =
      third   =
      wrapper = undefined

      it 'should respond to it', ->
        expect(subject().it).toBeDefined()

      describe '#it', ->
        describe 'without arguments', ->
          beforeEach ->
            wrapper = subject()

          it 'should return empty arguments list', ->
            expect(wrapper.it()).toEqual [' ', undefined]

        describe 'first - function', ->
          beforeEach ->
            first = ->
            wrapper = subject(first)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', first]

        describe 'first - string, second - function', ->
          beforeEach ->
            first = 'some text'
            second = ->
            wrapper = subject(first, second)

          it 'should return arguments list with description and function', ->
            expect(wrapper.it()).toEqual [first, second]

        describe 'first - function, second - string', ->
          beforeEach ->
            first = ->
            second = 'some text'
            wrapper = subject(first, second)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', first]

        describe 'first - function, second - function', ->
          beforeEach ->
            first = -> 'first'
            second = -> 'second'
            wrapper = subject(first, second)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', first]

        describe 'first - string, second - string', ->
          beforeEach ->
            first = 'first'
            second = 'second'
            wrapper = subject(first, second)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [first, undefined]

        describe 'first - null, second - string', ->
          beforeEach ->
            first = null
            second = 'second'
            wrapper = subject(first, second)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', undefined]

        describe 'first - null, second - function', ->
          beforeEach ->
            first = null
            second = -> 'second'
            wrapper = subject(first, second)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', second]

        describe 'first - string, second - function, third - function', ->
          beforeEach ->
            first = 'first'
            second = -> 'second'
            third = -> 'third'
            wrapper = subject(first, second, third)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [first, second]

        describe 'first - string, second - string, third - function', ->
          beforeEach ->
            first = 'first'
            second = 'second'
            third = -> 'third'
            wrapper = subject(first, second, third)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [first, undefined]

        describe 'first - null, second - function, third - function', ->
          beforeEach ->
            first = null
            second = -> 'second'
            third = -> 'third'
            wrapper = subject(first, second, third)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', second]

        describe 'first - null, second - string, third - function', ->
          beforeEach ->
            first = null
            second = 'second'
            third = -> 'third'
            wrapper = subject(first, second, third)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', undefined]

        describe 'first - function, second - string, third - string', ->
          beforeEach ->
            first = -> 'first'
            second = 'second'
            third = 'third'
            wrapper = subject(first, second, third)

          it 'should return arguments list with empty description and existing function', ->
            expect(wrapper.it()).toEqual [' ', first]
