define 'utils', ->
  (object)->
    {
      cropFrom: (value)->
        index = object.indexOf(value)
        delta = object.length - index

        object.splice(index, delta)

        object

      first: -> object[0]

      isEmpty: ->
        for val in object
          return false
        true

      keys: -> key for key of object when object.hasOwnProperty(key)

    }
