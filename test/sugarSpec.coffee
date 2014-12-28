describe 'JasmineSugar', ->
  JasmineSugar = require('../src/sugar')
  subject =
  jasmine_mock = undefined

  beforeEach ->
    jasmine_mock = jasmine.createSpyObj 'jasmineMock', ['it', 'iit']
    subject = new JasmineSugar({jasmine: jasmine_mock})

  it 'should be defined', ->
    expect(subject).toBeDefined()

  it 'should respond to it', ->
    expect(subject.it).toBeDefined()
    expect(typeof(subject.it)).toBe 'function'

  it 'should respond to iit', ->
    expect(subject.iit).toBeDefined()
    expect(typeof(subject.iit)).toBe 'function'

  it 'should not fails with bad or empty context', ->
    expect(=> new JasmineSugar()).not.toThrow(new TypeError("Cannot read property 'jasmine' of undefined"))
    expect(=> new JasmineSugar()).not.toThrow(jasmine.any(Error))
    expect(=> new JasmineSugar({})).not.toThrow(jasmine.any(Error))

  describe '#it', ->
    original_function = ->

    beforeEach ->
      subject.it original_function

    it 'should call jasmine.it function', ->
      expect(jasmine_mock.it).toHaveBeenCalled()
      expect(jasmine_mock.it.calls.count()).toBe 1
      expect(jasmine_mock.it.calls.argsFor(0)[0]).toBe ' '
      expect(jasmine_mock.it.calls.argsFor(0)[1]).toBe original_function

    describe 'with description', ->
      description = 'some text'

      beforeEach ->
        jasmine_mock.it.calls.reset()
        subject.it description, original_function

      it 'should call jasmine.it with description', ->
        expect(jasmine_mock.it).toHaveBeenCalled()
        expect(jasmine_mock.it.calls.count()).toBe 1
        expect(jasmine_mock.it.calls.argsFor(0)[0]).toBe description
        expect(jasmine_mock.it.calls.argsFor(0)[1]).toBe original_function

  describe '#iit', ->
    original_function = ->

    beforeEach ->
      subject.iit original_function

    it 'should call jasmine.it function', ->
      expect(jasmine_mock.iit).toHaveBeenCalled()
      expect(jasmine_mock.iit.calls.count()).toBe 1
      expect(jasmine_mock.iit.calls.argsFor(0)[0]).toBe ' '
      expect(jasmine_mock.iit.calls.argsFor(0)[1]).toBe original_function

    describe 'with description', ->
      description = 'some text'

      beforeEach ->
        jasmine_mock.iit.calls.reset()
        subject.iit description, original_function

      it 'should call jasmine.it with description', ->
        expect(jasmine_mock.iit).toHaveBeenCalled()
        expect(jasmine_mock.iit.calls.count()).toBe 1
        expect(jasmine_mock.iit.calls.argsFor(0)[0]).toBe description
        expect(jasmine_mock.iit.calls.argsFor(0)[1]).toBe original_function
