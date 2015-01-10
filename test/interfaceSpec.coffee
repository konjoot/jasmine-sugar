define ['interface', 'sharedExamples'], (Interface, SE) ->
  describe 'Interface', ->
    subject         =
    JasmineMock     =
    WrapperMock     =
    ArgsWrapperMock = undefined

    beforeEach ->
      WrapperMock     = jasmine.createSpyObj 'WrapperMock', ['it']
      ArgsWrapperMock = jasmine.createSpy('ArgsWrapperMock').and.returnValue WrapperMock
      JasmineMock     = jasmine.createSpyObj 'JasmineMock', ['it', 'iit', 'fit', 'xit']
      subject         = new Interface(JasmineMock, ArgsWrapperMock)

    it 'should be defined', ->
      expect(subject).toBeDefined()

    it 'should respond to it', ->
      expect(subject.it).toBeDefined()
      expect(typeof(subject.it)).toBe 'function'

    it 'should respond to iit', ->
      expect(subject.iit).toBeDefined()
      expect(typeof(subject.iit)).toBe 'function'

    it 'should not fails with bad or empty context', ->
      expect(=> new Interface()).not.toThrow(new TypeError("Cannot read property 'jasmine' of undefined"))
      expect(=> new Interface()).not.toThrow(jasmine.any(Error))
      expect(=> new Interface({})).not.toThrow(jasmine.any(Error))

    describe 'it, iit, fit, xit should work identically', ->
      SE.expects_it_like_behaviour_from('it')
      SE.expects_it_like_behaviour_from('iit')
      SE.expects_it_like_behaviour_from('fit')
      SE.expects_it_like_behaviour_from('xit')

    describe '#set', ->

      it 'should be defined', ->
        expect(subject.set).toBeDefined()
