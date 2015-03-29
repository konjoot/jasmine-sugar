define ['NewAnalyzer', 'Utils'], (Analyzer, u)->

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
      processibleChars = u(Analyzer('SPECIAL_CHARS')).values()

      beforeEach ->
        spy = jasmine.createSpy('resolve')
        subject  = Analyzer('charFilter')
        resolved = Analyzer('resolved')
        resolve  = Analyzer('resolve')
        Analyzer('resolved', undefined)
        spy.calls.reset()

      afterEach -> Analyzer('resolve', resolve)

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

      describe 'inner state', ->
        cases = [
          { value: "\n"
          state:
            endOfLine:        true
            escape:           undefined
            quote:            undefined
            doubleQuote:      undefined
            openParenthesis:  undefined
            closeParenthesis: undefined }
          { value: '\\'
          state:
            endOfLine:        undefined
            escape:           true
            quote:            undefined
            doubleQuote:      undefined
            openParenthesis:  undefined
            closeParenthesis: undefined }
          { value: "'"
          state:
            endOfLine:        undefined
            escape:           undefined
            quote:            true
            doubleQuote:      undefined
            openParenthesis:  undefined
            closeParenthesis: undefined }
          { value: '"'
          state:
            endOfLine:        undefined
            escape:           undefined
            quote:            undefined
            doubleQuote:      true
            openParenthesis:  undefined
            closeParenthesis: undefined }
          { value: '('
          state:
            endOfLine:        undefined
            escape:           undefined
            quote:            undefined
            doubleQuote:      undefined
            openParenthesis:  true
            closeParenthesis: undefined }
          { value: ')'
          state:
            endOfLine:        undefined
            escape:           undefined
            quote:            undefined
            doubleQuote:      undefined
            openParenthesis:  undefined
            closeParenthesis: true      }
        ]

        for exam in cases
          do (exam = exam)->
            describe "in case of #{JSON.stringify(exam.value)}", ->

              beforeEach ->
                Analyzer('crntChar', exam.value)
                Analyzer('charFilter')()

              for param, value of exam.state
                do (param = param, value = value) ->
                  it "#{param} should equal #{value}", ->
                    expect(Analyzer(param)()).toBe value

    describe 'escapeTracker', ->
      cases = [
        { escape: undefined
        escaped:
            before: undefined
            after: undefined }
        { escape: true
        escaped:
            before: undefined
            after: true }
        { escape: undefined
        escaped:
            before: true
            after: undefined }
        { escape: true
        escaped:
            before: true
            after: undefined }
      ]

      for exam in cases
        do (exam = exam)->
          describe "in case when escape = #{JSON.stringify(exam.escape)} and escaped = #{JSON.stringify(exam.escaped.before)}", ->
            escape  =
            escaped = undefined

            beforeEach ->
              escape  = Analyzer('escape')
              escaped = Analyzer('escaped')
              Analyzer('escape', exam.escape)
              Analyzer('escaped', exam.escaped.before)
              Analyzer('escapeTracker')()

            it 'should not update escape', ->
              expect(escape()).toBe exam.escape

            it "should change escaped to #{JSON.stringify(exam.escaped.after)}", ->
              expect(escaped()).toBe exam.escaped.after

    describe 'callInChain', ->
      func1 = jasmine.createSpy 'func1'
      func2 = jasmine.createSpy('func2').and.callFake -> Analyzer('resolved', true)
      func3 = jasmine.createSpy('func3')

      beforeEach ->
        Analyzer('resolved', undefined)
        subject = Analyzer('callInChain')

      it 'should call given methods in chain', ->
        subject func1, func2
        expect(func1).toHaveBeenCalledWith()
        expect(func2).toHaveBeenCalledWith()

      it 'should return if resolved', ->
        subject func1, func2, func3
        expect(func1).toHaveBeenCalledWith()
        expect(func2).toHaveBeenCalledWith()
        expect(func3).not.toHaveBeenCalled()


    # describe 'stringTracker', ->
    #   cases = [
    #     { char'"',
    #     strings: []
    #     escaped: undefined
    #     inString: true }
    #     { char'"',
    #     strings: ['"']
    #     escaped: undefined
    #     inString: undefined }
    #     { char'"',
    #     strings: ["'"]
    #     escaped: undefined
    #     inString: true }
    #     { char"'",
    #     strings: []
    #     escaped: undefined
    #     inString: true }
    #     { char"'",
    #     strings: ["'"]
    #     escaped: undefined
    #     inString: undefined }
    #     { char"'",
    #     strings: ['"']
    #     escaped: undefined
    #     inString: true }
    #     { char'"',
    #     strings: []
    #     escaped: true
    #     inString: undefined }
    #     { char'"',
    #     strings: ['"']
    #     escaped: true
    #     inString: true }
    #     { char'"',
    #     strings: ["'"]
    #     escaped: true
    #     inString: true }
    #     { char"'",
    #     strings: []
    #     escaped: true
    #     inString: undefined }
    #     { char"'",
    #     strings: ["'"]
    #     escaped: true
    #     inString: true }
    #     { char"'",
    #     strings: ['"']
    #     escaped: true
    #     inString: true }
    #   ]

      # it 'should return unless quote or doubleQuote', ->

    describe 'main function', ->
      spy           =
      crntChar      =
      charFilter    =
      escapeTracker =
      stringTracker = undefined

      beforeEach ->
        spy           = jasmine.createSpy('charFilter')
        crntChar      = Analyzer('crntChar')
        charFilter    = Analyzer('charFilter')
        escapeTracker = Analyzer('escapeTracker')
        stringTracker = Analyzer('stringTracker')
        Analyzer('crntChar', undefined)
        Analyzer('callInChain', spy)
        spy.calls.reset()

      afterEach -> Analyzer('charFilter', charFilter)

      it 'should set crntChar', ->
        expect(crntChar()).toBeUndefined()
        subject('a')
        expect(crntChar()).toBe 'a'

      it 'should call filters in chain', ->
        subject('a')
        expect(spy).toHaveBeenCalledWith(
          escapeTracker
          charFilter
          stringTracker )


