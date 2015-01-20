define ['contextFactory', 'utils'], (ContextFactory, u) ->
  describe 'ContextFactory', ->
    it 'should be defined', ->
      expect(ContextFactory).toBeDefined()

    it 'should be a function', ->
      expect(ContextFactory).toBeAFunction()

    describe 'returnable DSL object', ->
      subject = undefined

      beforeEach ->
        subject = new ContextFactory()

      it 'interface', ->
        expect(u(subject).keys()).toEqual ['is']

      describe '#is', ->
        xit 'pending', ->
