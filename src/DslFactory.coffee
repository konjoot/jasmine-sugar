define 'DslFactory', ->
  _offset = ''

  factory = (name, Evaluator, Jasmine, Store)->
    self = undefined
    name = name

    {
      is: (argsFunction)->
        return unless argsFunction?
        self = this
        self.name = name
        self.func = argsFunction

        Jasmine.instance.beforeEach ->
          eval("#{self.name} = self.evaluate();")

          if Store.failed? and Store.failed[name]?
            eval("#{__func.name} = __func.evaluate();") for _, __func of Store.failed[name]

        Jasmine.instance.afterEach ->
          eval("#{self.name} = void 0;")

          if Store.failed? and Store.failed[name]?
            for _, __func of Store.failed[name]
              eval("#{__func.name} = void 0;")
              Evaluator.flush __func.name

          Evaluator.flush self.name

      evaluate: -> Evaluator.perform(self)

    }

  factoryReplacer = (match, p1)->
    return unless p1?
    return match if p1.length < 1
    match.replace(p1, p1 + _offset)

  {
    source: (offset, name)->
      _offset = offset
      "(#{factory.toString().replace(/(\s*){1}.*/g, factoryReplacer)})('#{name}', Evaluator, Jasmine, Store);\n"
  }
