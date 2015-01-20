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

      describe '#properties', ->
        describe 'no callback', ->
          xit 'pending'

        describe 'empty callback', ->
          xit 'pending'

        describe 'one function in callback', ->
          xit 'pending'

        describe 'multiple functions in callback', ->
          xit 'pending'

        describe 'abracadabra in context', ->
          xit 'pending'

        describe 'valid javascript in context', ->
          xit 'pending'

      describe '#PreparedContext', ->
        describe 'no callback', ->
          xit 'pending'

        describe 'empty callback', ->
          xit 'pending'

        describe 'one function in callback', ->
          xit 'pending'

        describe 'multiple functions in callback', ->
          xit 'pending'

        describe 'abracadabra in context', ->
          xit 'pending'

        describe 'valid javascript in context', ->
          xit 'pending'

