describe 'JasmineSugar.Interface', ->
  subject         =
  JasmineMock     =
  WrapperMock     =
  ArgsWrapperMock = undefined

  beforeEach ->
    WrapperMock     = jasmine.createSpyObj 'WrapperMock', ['it', 'iit']
    ArgsWrapperMock = jasmine.createSpy('ArgsWrapperMock').and.returnValue WrapperMock
    JasmineMock     = jasmine.createSpyObj 'JasmineMock', ['it', 'iit']
    subject         = new JasmineSugar.Interface(JasmineMock, ArgsWrapperMock)

  it 'should be defined', ->
    expect(subject).toBeDefined()

  it 'should respond to it', ->
    expect(subject.it).toBeDefined()
    expect(typeof(subject.it)).toBe 'function'

  it 'should respond to iit', ->
    expect(subject.iit).toBeDefined()
    expect(typeof(subject.iit)).toBe 'function'

  it 'should not fails with bad or empty context', ->
    expect(=> new JasmineSugar.Interface()).not.toThrow(new TypeError("Cannot read property 'jasmine' of undefined"))
    expect(=> new JasmineSugar.Interface()).not.toThrow(jasmine.any(Error))
    expect(=> new JasmineSugar.Interface({})).not.toThrow(jasmine.any(Error))

  describe '#it', ->
    original_function = ->

    beforeEach ->
      subject.it original_function

    it 'should call jasmine.it function', ->
      expect(JasmineMock.it).toHaveBeenCalled()
      expect(JasmineMock.it.calls.count()).toBe 1

    it 'should call ArgsWrapper', ->
      expect(ArgsWrapperMock).toHaveBeenCalled()
      expect(ArgsWrapperMock.calls.count()).toBe 1
      expect(ArgsWrapperMock.calls.argsFor(0)[0][0]).toBe original_function

    it 'should call WrapperMock.it', ->
      expect(WrapperMock.it).toHaveBeenCalled()
      expect(WrapperMock.it.calls.count()).toBe 1
      expect(WrapperMock.it.calls.argsFor(0).length).toBe 0

  describe '#iit', ->
    original_function = ->

    beforeEach ->
      subject.iit original_function

    it 'should call jasmine.iit function', ->
      expect(JasmineMock.iit).toHaveBeenCalled()
      expect(JasmineMock.iit.calls.count()).toBe 1

    it 'should call ArgsWrapper', ->
      expect(ArgsWrapperMock).toHaveBeenCalled()
      expect(ArgsWrapperMock.calls.count()).toBe 1
      expect(ArgsWrapperMock.calls.argsFor(0)[0][0]).toBe original_function

    it 'should call WrapperMock.it', ->
      expect(WrapperMock.it).toHaveBeenCalled()
      expect(WrapperMock.it.calls.count()).toBe 1
      expect(WrapperMock.it.calls.argsFor(0).length).toBe 0
