define 'CallbackWrapper',
['Store',
 'Context',
 'Jasmine',
 'Evaluator',
 'CallbackFormatter'],
(_Store_,
 _Context_,
 _Jasmine_,
 _Evaluator_,
 _CallbackFormatter_)->

  (fn,
   Store = _Store_,
   Context = _Context_,
   Jasmine = _Jasmine_,
   Evaluator = _Evaluator_,
   CallbackFormatter = _CallbackFormatter_)->

    evaluator = new Evaluator()

    @prepareCallback = ->
      return '' unless fn?

      Formatter = CallbackFormatter()

      Formatter.push(char) for char in fn.toString()

      eval("(#{Formatter.result()});")

    @run = ->
      @prepareCallback().call Context.get()

    this


# Error
# name: ReferenceError
# message: 'collection is not defined'
