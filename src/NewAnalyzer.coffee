define 'NewAnalyzer', ['Utils'], (u)->

  privateFunc = ->
    console.log 'I am private'

  Analyzer = ->
    unless u(u(this).keys()).isEmpty()
      console.log 'I am NewAnalyzer'

  Analyzer::private = (name)=> eval(name)

  Analyzer
