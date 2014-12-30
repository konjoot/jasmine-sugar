describe 'JasmineSugar.Arguments', ->
  subject = undefined

  beforeEach ->
    subject = new JasmineSugar.Arguments()

  it 'should be defined', ->
    expect(subject).toBeDefined()

  describe 'Wrapper', ->
    fn      =
    descr   =
    wrapper = undefined

    it 'should respond to it', ->
      expect(subject().it).toBeDefined()

    describe '#it', ->
      describe 'without arguments', ->
        beforeEach ->
          wrapper = subject()

        it 'should return empty arguments list', ->
          expect(wrapper.it()).toEqual []

      describe 'first - function', ->
        beforeEach ->
          fn = ->
          wrapper = subject(fn)

        it 'should return arguments list with empty description and existing function', ->
          expect(wrapper.it()).toEqual [' ', fn]

      describe 'first - string, second - function', ->
        beforeEach ->
          fn = ->
          descr = 'some text'
          wrapper = subject(descr, fn)

        it 'should return arguments list with description and function', ->
          expect(wrapper.it()).toEqual [descr, fn]

      describe 'first - function, second - string', ->
        beforeEach ->
          fn = ->
          descr = 'some text'
          wrapper = subject(fn, descr)

        it 'should return arguments list with empty description and existing function', ->
          expect(wrapper.it()).toEqual [' ', fn]

      describe 'first - function, second - function', ->
      describe 'first - string, second - string', ->
      describe 'first - null, second - string', ->
      describe 'first - null, second - function', ->
      describe 'first - string, second - function, third - function', ->
      describe 'first - string, second - string, third - function', ->
      describe 'first - null, second - function, third - function', ->
      describe 'first - null, second - string, third - function', ->
      describe 'first - function, second - string, third - string', ->

# TODO: should ignore all arguments after first function