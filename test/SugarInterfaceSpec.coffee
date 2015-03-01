define ['Squire'], (Squire) ->
  injector = new Squire()

  xdescribe 'SugarInterface', ->
    subject         =
    SugarInterface       =
    WrapperMock     =
    JasmineMock     =
    ArgsWrapperMock = undefined

    beforeEach (done)->
      WrapperMock     = jasmine.createSpyObj('WrapperMock', ['it', 'iit', 'describe'])
      ArgsWrapperMock = jasmine.createSpy('ArgsWrapperMock').and.returnValue WrapperMock
      JasmineMock     = jasmine.createSpyObj 'JasmineMock', ['describe', 'it', 'iit', 'fit', 'xit', 'beforeEach', 'afterEach']

      injector.mock('ArgumentsWrapper', ArgsWrapperMock).store 'ArgumentsWrapper'
      injector.require ['SugarInterface', 'mocks'], (SugarInterfaceModule, mocks)->
        ArgsWrapperMock = mocks.store.ArgumentsWrapper
        WrapperMock     = ArgsWrapperMock()
        SugarInterface  = SugarInterfaceModule
        subject         = new SugarInterface(JasmineMock)
        done()

    it 'should be defined', ->
      expect(subject).toBeDefined()

    it 'should respond to it', ->
      expect(subject.it).toBeDefined()
      expect(subject.it).toBeAFunction()

    it 'should respond to iit', ->
      expect(subject.iit).toBeDefined()
      expect(subject.iit).toBeAFunction()

    it 'should not fails with bad or empty context', ->
      expect(=> new SugarInterface()).not.toThrow(new TypeError("Cannot read property 'jasmine' of undefined"))
      expect(=> new SugarInterface()).not.toThrow(jasmine.any(Error))
      expect(=> new SugarInterface({})).not.toThrow(jasmine.any(Error))

    describe 'it, iit, fit, xit should work identically', ->
      execute = (name)->
        describe "##{name}", ->
          args = undefined
          original_function = ->

          beforeEach ->
            args = [ original_function ]
            ArgsWrapperMock.calls.reset()
            WrapperMock.it.calls.reset()
            subject["#{name}"].apply this, args

          it "should call jasmine.#{name} function", ->
            expect(JasmineMock["#{name}"]).toHaveBeenCalled()
            expect(JasmineMock["#{name}"].calls.count()).toBe 1

          it 'should call ArgsWrapper', ->
            expect(ArgsWrapperMock).toHaveBeenCalled()
            expect(ArgsWrapperMock.calls.count()).toBe 1
            expect(ArgsWrapperMock.calls.argsFor(0)).toEqual args

          it 'should call WrapperMock.it', ->
            expect(WrapperMock.it).toHaveBeenCalled()
            expect(WrapperMock.it.calls.count()).toBe 1
            expect(WrapperMock.it.calls.argsFor(0).length).toBe 0

      execute name for name in ['it', 'iit', 'fit', 'xit']

    describe '#describe', ->

      it 'should be defined', ->
        expect(subject.describe).toBeDefined()

      it 'should not raise an error', ->
        expect(=> subject.describe(-> collection.is 'something')).not.toThrow new ReferenceError('collection is not defined')
        expect(=> subject.describe(-> collection.is 'something')).not.toThrow jasmine.any(Error)
