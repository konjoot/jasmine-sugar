define 'CallbackWrapper', ['Context', 'CallbackFormatter'], (_Context_, _CallbackFormatter_)->

  (fn, Context = _Context_(), CallbackFormatter = _CallbackFormatter_)->

    @prepareCallback = ->
      return '' unless fn?

      Formatter = CallbackFormatter()

      Formatter.push(char) for char in fn.toString()

      Formatter.result()

    @run = ->
      @prepareCallback().call Context()

    this


# Error
# name: ReferenceError
# message: 'collection is not defined'
