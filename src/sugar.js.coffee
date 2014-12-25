JasmineSugar = (context)->
  jasmine = (context && context.jasmine) || {}

  @it = (fn)->
    jasmine.it.call(this, ' ', fn)

  @iit = (fn)->
    jasmine.iit.call(this, ' ', fn)

  this