root = exports ? this
root.JasmineSugar = JasmineSugar ? {}

JasmineSugar.Utils = (object)=>
  {
    without: (value)->
      index = object.indexOf(value) || 1
      object.splice(index, 1)
      {
        cropToEnd: ->
          object.splice(index, 0, value)[0..index-1]
      }
  }
