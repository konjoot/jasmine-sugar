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

    describe 'dump', ->
      xit 'pending dump tests', ->

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
      unresolve = jasmine.createSpy 'unresolve'

      beforeEach ->
        Analyzer('resolved', undefined)
        subject   = Analyzer('callInChain')
        Analyzer('unresolve', unresolve)

      it 'should call given methods in chain', ->
        subject func1, func2
        expect(func1).toHaveBeenCalledWith()
        expect(func2).toHaveBeenCalledWith()

      it 'should return if resolved', ->
        subject func1, func2, func3
        expect(func1).toHaveBeenCalledWith()
        expect(func2).toHaveBeenCalledWith()
        expect(func3).not.toHaveBeenCalled()

      it 'should unresolve on start', ->
        subject()
        expect(unresolve).toHaveBeenCalledWith()


    describe 'stringTracker', ->
      cases = [
        { escaped: undefined
        chars: [
          { value: '"'
          inString: [
            { before: undefined, after: '"'      , resolved: true }
            { before: '"',       after: undefined, resolved: true }
            { before: "'",       after: "'"      , resolved: true }
          ] }
          { value: "'"
          inString: [
            { before: undefined, after: "'"      , resolved: true }
            { before: "'",       after: undefined, resolved: true }
            { before: '"',       after: '"'      , resolved: true }
          ] }
          { value: "a"
          inString: [
            { before: undefined, after: undefined, resolved: undefined }
            { before: "'",       after: "'"      , resolved: true }
            { before: '"',       after: '"'      , resolved: true }
          ] }
        ] }
        { escaped: true
        chars: [
          { value: '"'
          inString: [
            { before: undefined, after: undefined, resolved: true }
            { before: '"',       after: '"'      , resolved: true }
            { before: "'",       after: "'"      , resolved: true }
          ] }
          { value: "'"
          inString: [
            { before: undefined, after: undefined, resolved: true }
            { before: "'",       after: "'"      , resolved: true }
            { before: '"',       after: '"'      , resolved: true }
          ] }
          { value: "a"
          inString: [
            { before: undefined, after: undefined, resolved: undefined }
            { before: "'",       after: "'"      , resolved: true }
            { before: '"',       after: '"'      , resolved: true }
          ] }
        ] }
      ]

      for exam in cases
        do (exam = exam)->
          describe "when escaped = #{JSON.stringify(exam.escaped)}", ->
            beforeEach -> Analyzer('escaped', exam.escaped)

            for char in exam.chars
              do (char = char)->
                describe "and currentChar = #{JSON.stringify(char.value)}", ->
                  beforeEach ->
                    Analyzer('crntChar', char.value)
                    Analyzer('charFilter')()

                  for subject in char.inString
                    do (subject = subject)->
                      describe "and inString = #{JSON.stringify(subject.before)}", ->
                        beforeEach ->
                          Analyzer('inString', subject.before)
                          Analyzer('resolved', undefined)

                        it "inString should became #{JSON.stringify(subject.after)}", ->
                          Analyzer('stringTracker')()
                          expect(Analyzer('inString')()).toBe subject.after

                        it "resolved should be #{JSON.stringify(subject.resolved)}", ->
                          Analyzer('stringTracker')()
                          expect(Analyzer('resolved')()).toBe subject.resolved

    describe 'parenthesesTracker', ->
      cases = [
        { crntChar: '('
        escaped: undefined
        cases: [
          { before: [], after: ['('] }
          { before: ['('], after: ['(', '('] }
          { before: ['(', '('], after: ['(', '(', '('] }
        ] }
        { crntChar: ')'
        escaped: undefined
        cases: [
          { before: [], after: [] }
          { before: ['('], after: [] }
          { before: ['(', '('], after: ['('] }
        ] }
        { crntChar: 'a'
        escaped: undefined
        cases: [
          { before: [], after: [] }
          { before: ['('], after: ['('] }
          { before: ['(', '('], after: ['(', '('] }
        ] }
        { crntChar: '('
        escaped: true
        cases: [
          { before: [], after: [] }
          { before: ['('], after: ['('] }
          { before: ['(', '('], after: ['(', '('] }
        ] }
        { crntChar: ')'
        escaped: true
        cases: [
          { before: [], after: [] }
          { before: ['('], after: ['('] }
          { before: ['(', '('], after: ['(', '('] }
        ] }
        { crntChar: 'a'
        escaped: true
        cases: [
          { before: [], after: [] }
          { before: ['('], after: ['('] }
          { before: ['(', '('], after: ['(', '('] }
        ] }
      ]

      for exam in cases
        do (exam = exam)->
          describe "when currentChar = #{JSON.stringify(exam.crntChar)}", ->
            beforeEach ->
              Analyzer('resolved', undefined)
              Analyzer('crntChar', exam.crntChar)
              Analyzer('escaped', exam.escaped)
              Analyzer('charFilter')()

            for ex in exam.cases
              do (ex = ex)->
                it "should change parentheses from #{JSON.stringify(ex.before)} to #{JSON.stringify(ex.after)}", ->
                  Analyzer('parentheses', ex.before)
                  Analyzer('parenthesesTracker')()
                  expect(Analyzer('parentheses')()).toBeEqual ex.after

    describe 'dslTracker', ->
      cases = [
        { dump: '.is('
        crntChar: '('
        cases: [
          { escaped: undefined
          inString: undefined
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: 1 }
            { parentheses: []
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: 2 }
          ] }
          { escaped: true
          inString: undefined
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: undefined }
          ] }
          { escaped: undefined
          inString: true
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: undefined }
          ] }
        ] }
        { dump: 'is(('
        crntChar: '('
        cases: [
          { escaped: undefined
          inString: undefined
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: []
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: undefined }
          ] }
          { escaped: true
          inString: undefined
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: undefined }
          ] }
          { escaped: undefined
          inString: true
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: undefined }
          ] }
        ] }
        { dump: ''
        crntChar: ')'
        cases: [
          { escaped: undefined
          inString: undefined
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: []
            inDslParams:
              before: 1
              after: undefined }
            { parentheses: []
            inDslParams:
              before: 2
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 1
              after: undefined }
            { parentheses: ['(', '(']
            inDslParams:
              before: 2
              after: undefined }
          ] }
          { escaped: true
          inString: undefined
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: undefined }
          ] }
          { escaped: undefined
          inString: true
          cases: [
            { parentheses: ['(']
            inDslParams:
              before: undefined
              after: undefined }
            { parentheses: ['(']
            inDslParams:
              before: 2
              after: 2 }
            { parentheses: ['(', '(']
            inDslParams:
              before: undefined
              after: undefined }
          ] }
        ] }
      ]

      for exam in cases
        do (exam = exam)->
          describe "when dump = #{JSON.stringify(exam.dump)}
                    and crntChar = #{JSON.stringify(exam.crntChar)}", ->
            beforeEach ->
              Analyzer('dumped', exam.dump)
              Analyzer('crntChar', exam.crntChar)
              Analyzer('charFilter')()

            for ex in exam.cases
              do (ex = ex)->
                for e in ex.cases
                  do (e = e)->
                    describe "and escaped = #{JSON.stringify(ex.escaped)}
                              and inString = #{JSON.stringify(ex.inString)}
                              and parentheses =  #{JSON.stringify(e.parentheses)}", ->
                      beforeEach ->
                        Analyzer('escaped', ex.escaped)
                        Analyzer('inString', ex.inString)
                        Analyzer('parentheses', e.parentheses)
                        Analyzer('inDslParams', e.inDslParams.before)
                        Analyzer('dslTracker')()

                      it "inDslParams should became #{e.inDslParams.after}", ->
                        expect(Analyzer('inDslParams')()).toBe e.inDslParams.after



    describe 'main function', ->
      spy                =
      crntChar           =
      charFilter         =
      dslTracker         =
      escapeTracker      =
      stringTracker      =
      parenthesesTracker = undefined

      beforeEach ->
        spy                = jasmine.createSpy('charFilter')
        crntChar           = Analyzer('crntChar')
        charFilter         = Analyzer('charFilter')
        dslTracker         = Analyzer('dslTracker')
        escapeTracker      = Analyzer('escapeTracker')
        stringTracker      = Analyzer('stringTracker')
        parenthesesTracker = Analyzer('parenthesesTracker')
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
          stringTracker
          parenthesesTracker
          dslTracker
        )


