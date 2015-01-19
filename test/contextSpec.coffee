define ['context'], (Context) ->
  fdescribe 'Context', ->
    subject = undefined

    describe 'constructor', ->
      it 'should be defined', ->
        expect(Context).toBeDefined()

    describe 'constructed Contex', ->
      beforeEach ->
        subject = new Context()

      it 'should respond to defineProperty', ->
        expect(subject.defineProperty).toBeDefined()
        expect(typeof(subject.defineProperty)).toBe 'function'

      it 'should respond to properties', ->
        expect(subject.properties).toBeDefined()
        expect(typeof(subject.properties)).toBe 'object'

      describe '#defineProperty', ->
        it 'should affect internal context object with ', ->