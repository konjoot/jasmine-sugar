define ['NewAnalyzer'], (Analyzer)->

  fdescribe 'Analyzer', ->
    subject = undefined

    beforeEach ->
      subject = Analyzer()

    describe 'resolve', ->
      subject  =
      resolved = undefined

      beforeEach ->
        subject = Analyzer('resolve')
        resolved = Analyzer('resolved')
        Analyzer('resolved', undefined)

      it 'should set resolve to true', ->
        expect(resolved()).toBeUndefined()
        subject()
        expect(resolved()).toBeTruthy()
        subject()
        expect(resolved()).toBeTruthy()

    describe 'unresolve', ->
      subject  =
      resolved = undefined

      beforeEach ->
        subject = Analyzer('unresolve')
        resolved = Analyzer('resolved')
        Analyzer('resolved', undefined)

      it 'should set unresolve to true', ->
        expect(resolved()).toBeUndefined()
        subject()
        expect(resolved()).toBeUndefined()
        Analyzer('resolved', true)
        expect(resolved()).toBeTruthy()
        subject()
        expect(resolved()).toBeUndefined()

    describe 'charFilter', ->
      spy      =
      resolve  =
      resolved = undefined
      processibleChars = ["\n", '"', "'", '\\', '(', ')']

      beforeEach ->
        spy = jasmine.createSpy('resolve')
        subject  = Analyzer('charFilter')
        resolved = Analyzer('resolved')
        resolve  = Analyzer('resolve')
        Analyzer('resolved', undefined)
        spy.calls.reset()

      afterEach -> Analyzer('resolve', resolve)

      it 'should return if resolved', ->
        Analyzer('resolved', true)
        expect(subject()).toBeUndefined()
        expect(resolved()).toBeTruthy()

      it 'should resolve if crntChar not in processibleChars', ->
        Analyzer('resolve', spy)
        Analyzer('crntChar', 'a')
        subject()
        expect(spy).toHaveBeenCalledWith()

      it 'should not resolve if crntChar in processibleChars', ->
        Analyzer('resolve', spy)
        for char in processibleChars
          Analyzer('crntChar', char)
          subject()
          expect(spy).not.toHaveBeenCalled()

      describe 'inner state changes', ->
        cases = [
          { value: "\n",
            state:
              endOfLine:        true,
              escaped:          undefined,
              quote:            undefined,
              doubleQuote:      undefined,
              openParenthesis:  undefined,
              closeParenthesis: undefined
          },
          { value: "\n",
            state:
              endOfLine:        true,
              escaped:          undefined,
              quote:            undefined,
              doubleQuote:      undefined,
              openParenthesis:  undefined,
              closeParenthesis: undefined
          }
        ]



    describe 'main function', ->
      spy        =
      crntChar   =
      charFilter = undefined

      beforeEach ->
        spy        = jasmine.createSpy('charFilter')
        crntChar   = Analyzer('crntChar')
        charFilter = Analyzer('charFilter')
        Analyzer('crntChar', undefined)
        spy.calls.reset()

      afterEach -> Analyzer('charFilter', charFilter)


      it 'should set crntChar', ->
        expect(crntChar()).toBeUndefined()
        subject('a')
        expect(crntChar()).toBe 'a'

      it 'should call charFilter', ->
        Analyzer('charFilter', spy)
        expect(spy).not.toHaveBeenCalled()
        subject('a')
        expect(spy).toHaveBeenCalledWith()


