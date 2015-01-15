define ['interface', 'SharedExamples'], (Interface, SE) ->
  describe 'Interface', ->
    subject     =
    JasmineMock = undefined

    beforeEach ->
      JasmineMock = jasmine.createSpyObj 'JasmineMock', ['it', 'iit', 'fit', 'xit']
      subject     = new Interface(JasmineMock)

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

    fdescribe 'it, iit, fit, xit should work identically', ->
      SE.expects_it_like_behaviour_from('it')
      # SE.expects_it_like_behaviour_from('iit')
      # SE.expects_it_like_behaviour_from('fit')
      # SE.expects_it_like_behaviour_from('xit')

    describe '#set', ->

      it 'should be defined', ->
        expect(subject.set).toBeDefined()

      it 'should not raise an error', ->
        expect(=> subject.set(-> collection.letBe 'something')).not.toThrow(new ReferenceError('collection is not defined'))
        expect(=> subject.set(-> collection.letBe 'something')).not.toThrow(jasmine.any(Error))
