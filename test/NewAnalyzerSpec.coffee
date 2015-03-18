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
      resolved = undefined
      processibleChars = ['"', "'", '\\', '(', ')']

      beforeEach ->
        spy = jasmine.createSpy('resolve')
        subject  = Analyzer('charFilter')
        resolved = Analyzer('resolved')

      it 'should return if resolved', ->
        Analyzer('resolved', true)
        expect(subject()).toBeUndefined()
        expect(resolved()).toBeTruthy()

      fit 'should resolve if crntChar not in processibleChars', ->
        Analyzer('crntChar', 'a')
        Analyzer('resolve', spy)
        expect(subject()).toBeTruthy()
        expect(spy).toHaveBeenCalledWith()


    describe 'main function', ->
      spy        =
      crntChar   = undefined

      beforeEach ->
        spy = jasmine.createSpy('charFilter')
        crntChar = Analyzer('crntChar')

      it 'should set crntChar', ->
        expect(crntChar()).toBeUndefined()
        subject('a')
        expect(crntChar()).toBe 'a'

      it 'should call charFilter', ->
        Analyzer('charFilter', spy)
        expect(spy).not.toHaveBeenCalled()
        subject('a')
        expect(spy).toHaveBeenCalledWith()


