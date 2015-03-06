define 'Evaluator', ['Store'], (_Store_)->
  (Store = _Store_())->
    self = undefined
    properties = {} unless properties?

    callWithPreparedContext = ->
      eval "var #{__name} = __val;" for __name, __val of properties
      properties[self.name] = eval("(#{self.func.toString()})();")

    catcher = (e)->
      return unless e.name == 'ReferenceError'
      dependency = e.message.match(/^(\w+).*$/)[1]

      Store.failed ||= {}
      Store.failed[dependency] ||= {}
      Store.failed[dependency][self.name] = self

      undefined

    {
      perform: (obj)->
        self = obj

        try
          callWithPreparedContext()
        catch e
          catcher e

      flush: (name)->
        try
          delete properties[name]
          delete Store.failed[name]
        catch e
          catcher e
    }
