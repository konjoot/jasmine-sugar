define ['Analizer'], (Analizer)->
  describe 'Analizer', ->
    subject = undefined

    beforeEach ->
      Dumper = jasmine.createSpyObj('Dumper', ['push', 'buffer'])
      subject = Analizer()

    it 'interface', ->
      expect(subject).toHaveProperties [
        'push',
        'clean',
        'buffer',
        'analize',
        'inString',
        'endOfLine',
        'inCallback',
        'endMatched',
        'inDSLParams',
        'beginMatched',
        'callbackBegins'
      ]

    it 'all props should be undefined after initialization', ->
      expect(subject.inString).toBeUndefined()
      expect(subject.endOfLine).toBeUndefined()
      expect(subject.inCallback).toBeUndefined()
      expect(subject.endMatched).toBeUndefined()
      expect(subject.inDSLParams).toBeUndefined()
      expect(subject.beginMatched).toBeUndefined()
      expect(subject.callbackBegins).toBeUndefined()

    describe '.clean', ->
      caseOne = (subj)->
        subj.inString       =
        subj.endOfLine      =
        subj.inCallback     =
        subj.endMatched     =
        subj.inDSLParams    =
        subj.beginMatched   =
        subj.callbackBegins = true
        subj.clean()

      caseTwo = (subj)->
        subj.inString       =
        subj.endOfLine      =
        subj.inCallback     =
        subj.endMatched     =
        subj.inDSLParams    =
        subj.beginMatched   =
        subj.callbackBegins = false
        subj.clean()

      it 'should always reset [endOfLine, endMatched, beginMatched, callbackBegins]', ->
        caseOne(subject)
        expect(subject.inString).toBeTruthy()
        expect(subject.endOfLine).toBeUndefined()
        expect(subject.inCallback).toBeTruthy() # never reset inCallback
        expect(subject.endMatched).toBeUndefined()
        expect(subject.inDSLParams).toBeTruthy()
        expect(subject.beginMatched).toBeUndefined()
        expect(subject.callbackBegins).toBeUndefined()


      it 'should reset [inString, inDSLParams], only if they falsy', ->
        caseTwo(subject)
        expect(subject.inString).toBeUndefined()
        expect(subject.endOfLine).toBeUndefined()
        expect(subject.inCallback).toBeFalsy() # never reset inCallback
        expect(subject.endMatched).toBeUndefined()
        expect(subject.inDSLParams).toBeUndefined()
        expect(subject.beginMatched).toBeUndefined()
        expect(subject.callbackBegins).toBeUndefined()