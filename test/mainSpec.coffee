define ['main', 'utils'], (JasmineSugar, _) ->

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
            expect(_(context).keys()).toEqual ['jasmine']
            JasmineSugar.setup(context)

          it 'new context has new properties', ->
            expect(_(context).keys()).toEqual [
              'jasmine',
              'it',
              'fit',
              'set'
            ]

          it '#it is defined and is a function', ->
            expect(context.it).toBeDefined()
            expect(typeof(context.it)).toBe 'function'

          it '#fit is defined and is a function', ->
            expect(context.fit).toBeDefined()
            expect(typeof(context.fit)).toBe 'function'

          it '#set is defined and is a function', ->
            expect(context.set).toBeDefined()
            expect(typeof(context.set)).toBe 'function'

      describe 'jasmine without getEnv() present on origin context', ->
        beforeEach ->
          Jasmine = {}

          context =
            jasmine: Jasmine

        it 'should not extend context', ->
          expect(_(context).keys()).toEqual ['jasmine']
          JasmineSugar.setup(context)
          expect(_(context).keys()).toEqual ['jasmine']

      describe 'empty context', ->
        beforeEach ->
          context = {}

        it 'should not extend context', ->
          expect(_(context).keys()).toEqual []
          JasmineSugar.setup(context)
          expect(_(context).keys()).toEqual []

    describe 'new context', ->

      beforeEach ->
        Jasmine =
          getEnv: -> JasmineMock

        context =
          jasmine: Jasmine

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
