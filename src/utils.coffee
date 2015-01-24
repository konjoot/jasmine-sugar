define 'utils', ->

  type = (obj)->
    if obj == undefined or obj == null
      return String obj
    classToType = {
      '[object Boolean]' : 'boolean'  ,
      '[object Number]'  : 'number'   ,
      '[object String]'  : 'string'   ,
      '[object Function]': 'function' ,
      '[object Array]'   : 'array'    ,
      '[object Date]'    : 'date'     ,
      '[object RegExp]'  : 'regexp'   ,
      '[object Object]'  : 'object'   ,
      '[object Null]'    : 'null'
    }
    return classToType[Object.prototype.toString.call(obj)]

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

      isAFunction: -> object? && type(object) == 'function'

    }
