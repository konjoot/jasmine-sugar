define ['callback'], (Callback)->
  describe 'Callback', ->
    it 'should be defined', ->
      expect(Callback).toBeDefined()

    it 'should be a function', ->
      expect(Callback).toBeAFunction()

    describe 'constructed Callback', ->
      subject = undefined

      beforeEach ->
        subject = new Callback()

      it 'interface', ->
        expect(subject).toHaveProperties ['run', 'properties', 'PreparedContext']

      it 'run should be a function', ->
        expect(subject.run).toBeAFunction()

      it 'properties should be a function', ->
        expect(subject.properties).toBeAFunction()

      it 'PreparedContext should be a function', ->
        expect(subject.PreparedContext).toBeAFunction()
