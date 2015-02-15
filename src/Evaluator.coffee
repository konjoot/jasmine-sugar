define 'Evaluator', ['Store'], (_Store_)->
  (Store = _Store_)->
    self = undefined
    properties = {} unless properties?

    callWithPreparedContext = ->
      eval "var #{name} = val;" for name, val of properties
      properties[self.name] = eval("(#{self.func.toString()})();")

    catcher = (e)->
      return unless e.name = 'ReferenceError'
      dependency = e.message.match(/^(\w+).*$/)[1]

      Store.failed ||= {}
      Store.failed[dependency] ||= []
      Store.failed[dependency].push self

      undefined

    @perform = (obj)->
      self = obj

      try
        callWithPreparedContext()
      catch e
        catcher e

    this