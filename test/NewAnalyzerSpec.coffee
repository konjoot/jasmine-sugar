define ['NewAnalyzer'], (Analyzer)->

  describe 'Analyzer', ->
    subject = undefined

    beforeEach ->
      subject = new Analyzer

    fit 'privateFunc should be accessible now', ->
      expect(subject.private('privateFunc')).toBeAFunction()
      expect(Analyzer).toBeAFunction()
      subject.private('privateFunc')()
      Analyzer()