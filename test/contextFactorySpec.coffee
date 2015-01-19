define ['contextFactory', 'utils'], (ContextFactory, u) ->
  fdescribe 'ContextFactory', ->
    it 'should be defined', ->
      expect(ContextFactory).toBeDefined()

    it 'should be a function', ->
      expect(typeof(ContextFactory)).toBe 'function'

    describe 'returnable DSL object', ->
      subject = undefined

      beforeEach ->
        subject = new ContextFactory()

      it 'interface', ->
        expect(u(subject).keys()).toEqual ['is']

      describe '#is', ->
        xit 'pending', ->
