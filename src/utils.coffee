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
    classToType[Object.prototype.toString.call(obj)]


  objectToText = (obj)->
    strArray = []

    switch type(obj)
      when 'object'
        strArray.push "{"
        tmpArray = []

        for prop of obj
          tmpArray.push """#{prop}: #{objectToText(obj[prop])}"""

        strArray.push tmpArray.join()
        strArray.push "}"

      when 'array'
        strArray.push "["
        tmpArray = []

        for prop in obj
          tmpArray.push objectToText(prop)

        strArray.push tmpArray.join()
        strArray.push "]"

      when 'function'
        strArray.push """#{obj.toString()}"""

      else
        strArray.push JSON.stringify(obj)

    strArray.join('')

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
      isAnObject: -> object? && type(object) == 'object'

      toString: ->
        switch type(object)
          when 'function'
            """(#{object.toString()})"""
          when 'object', 'array'
            """(#{objectToText(object)})"""
          else
            JSON.stringify(object)
    }
