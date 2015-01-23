define ['main'], (JasmineSugar) ->
  describe 'JasmineSugar', ->
    context     =
    Jasmine     =
    JasmineMock = undefined

    beforeEach ->
      JasmineMock = jasmine.createSpyObj 'JasmineMock', ['it', 'fit', 'another']

    it 'should be defined', ->
      expect(JasmineSugar).toBeDefined()

    it 'should respond to setup', ->
      expect(JasmineSugar.setup).toBeDefined()

    describe '#setup', ->

      describe 'jasmine with getEnv() present on origin context', ->
        beforeEach ->
          Jasmine =
            getEnv: -> JasmineMock

          context =
            jasmine: Jasmine

        describe 'should properly extend context', ->
          beforeEach ->
            expect(context).toHaveProperties ['jasmine']
            JasmineSugar.setup(context)

          it 'new context has new properties', ->
            expect(context).toHaveProperties [
              'jasmine',
              'set',
              'it',
              'fit'
            ]

          it '#it is defined and is a function', ->
            expect(context.it).toBeDefined()
            expect(context.it).toBeAFunction()

          it '#fit is defined and is a function', ->
            expect(context.fit).toBeDefined()
            expect(context.fit).toBeAFunction()

          it '#set is defined and is a function', ->
            expect(context.set).toBeDefined()
            expect(context.set).toBeAFunction()

      describe 'jasmine without getEnv() present on origin context', ->
        beforeEach ->
          Jasmine = {}

          context =
            jasmine: Jasmine

        it 'should not extend context', ->
          expect(context).toHaveProperties ['jasmine']
          JasmineSugar.setup(context)
          expect(context).toHaveProperties ['jasmine']

      describe 'empty context', ->
        beforeEach ->
          context = {}

        it 'should not extend context', ->
          expect(context).not.toHaveProperties()
          JasmineSugar.setup(context)
          expect(context).not.toHaveProperties()

    describe 'new context', ->

      beforeEach ->
        Jasmine = getEnv: -> JasmineMock
        context = jasmine: Jasmine

        JasmineSugar.setup(context)

      describe '#it', ->
        args = undefined

        beforeEach ->
          args = ['one', ->]
          context.it(args...)

        it 'should call Interface.it', ->
          expect(JasmineMock.it).toHaveBeenCalled()
          expect(JasmineMock.it.calls.count()).toBe 1
          expect(JasmineMock.it.calls.argsFor(0)).toEqual args

      describe '#fit', ->
        args = undefined

        beforeEach ->
          args = ['one', ->]
          context.fit(args...)

        it 'should call Interface.it', ->
          expect(JasmineMock.fit).toHaveBeenCalled()
          expect(JasmineMock.fit.calls.count()).toBe 1
          expect(JasmineMock.fit.calls.argsFor(0)).toEqual args
