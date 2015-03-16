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
        resolved(undefined)

      it 'should set resolve to true', ->
        expect(resolved()).toBeUndefined()
        subject()
        expect(resolved()).toBeTruthy()
        subject()
        expect(resolved()).toBeTruthy()

    describe 'unresolve', ->
      resolve  =
      subject  =
      resolved = undefined

      beforeEach ->
        resolve = Analyzer('resolve')
        subject = Analyzer('unresolve')
        resolved = Analyzer('resolved')
        resolved(undefined)

      it 'should set unresolve to true', ->
        expect(resolved()).toBeUndefined()
        subject()
        expect(resolved()).toBeUndefined()
        resolved(true)
        expect(resolved()).toBeTruthy()
        subject()
        expect(resolved()).toBeUndefined()


