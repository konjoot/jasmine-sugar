define ['Analyzer'], (Analyzer)->
  describe 'Analyzer', ->
    subject = undefined

    beforeEach ->
      subject = Analizer()

    # it 'interface', ->
    #   expect(subject).toHaveProperties [
    #     'push',
    #     'clean',
    #     'buffer',
    #     'analize',
    #     'inString',
    #     'endOfLine',
    #     'inCallback',
    #     'endMatched',
    #     'inDSLParams',
    #     'beginMatched',
    #     'callbackBegins'
    #   ]

    describe '.'