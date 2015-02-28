define 'SugarInterface', ['ArgumentsWrapper', 'Jasmine', 'PrivateStore', 'Utils'], (_Wrapper_, _JasmineStore_, _Context_, u)->
  (Jasmine, Wrapper = _Wrapper_, JasmineStore = _JasmineStore_, Context = _Context_)->
    return {} unless Jasmine
    JasmineStore.set Jasmine

    for method in ['it', 'iit', 'fit', 'xit']
      if u(Jasmine[method]).isAFunction()
        this[method] = do (method = method)->
          ->
            Jasmine[method].apply(this,
              Wrapper(arguments...).it())

    for method in ['describe', 'fdescribe', 'xdescribe', 'ddescribe']
      if u(Jasmine[method]).isAFunction()
        this[method] = do (method = method)->
          ->
            Jasmine[method].apply(Context.set(this),
              Wrapper(arguments...).describe())

        this["_#{method}_"] = do (method = method)->
          ->
            Jasmine[method].apply(Context.set(this),
              Wrapper(arguments...)._describe_())

    this