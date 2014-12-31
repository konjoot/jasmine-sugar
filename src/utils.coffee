root = exports ? this
root.JasmineSugar = JasmineSugar ? {}

JasmineSugar.Utils = (object)=>
  {
    without: (value)->
      index = object.indexOf(value)
      delta = object.length - index
      object.splice(index, 1)

      {
        cropToEnd: ->
          object.splice(index, 0, value)
          object.splice(index, delta)

          this

        result: -> object

      }

    first: -> object[0]
  }
