do ->
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

  arraysEqual = (a, b)->
    return true if a == b
    return false if (a == null || b == null)
    return false if (a.length != b.length)

    for i in [0...a.length]
      return false if (a[i] != b[i])

    true

  keysOf = (obj)-> key for key of obj when obj.hasOwnProperty(key)

  isEmpty = (obj)->
    for key in obj
      return false

    true

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

    strArray.join('').replace /\s+/g, ' '

  beforeEach ->
    jasmine.addMatchers
      toBeATypeOf: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          result = {}
          result.pass = type(actual) == expected
          result

      toBeAFunction: (util, customEqualityTesters)->
        return compare: (actual, expected = 'function')->
          result = {}
          result.pass = type(actual) == expected
          result

      toBeAnObject: (util, customEqualityTesters)->
        return compare: (actual, expected = 'object')->
          result = {}
          result.pass = type(actual) == expected
          result

      toBeAnArray: (util, customEqualityTesters)->
        return compare: (actual, expected = 'array')->
          result = {}
          result.pass = type(actual) == expected
          result

      toBeAString: (util, customEqualityTesters)->
        return compare: (actual, expected = 'string')->
          result = {}
          result.pass = type(actual) == expected
          result

      toHaveProperties: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          result = {}
          result.pass = arraysEqual(keysOf(actual), expected) if expected?
          result.pass ||= keysOf(actual).length > 0
          result

      toBeEmpty: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          result = {}
          result.pass = isEmpty(actual)
          result

      toMatchSource: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          result = {}
          match = actual.toString().match(expected)
          result.pass = type(match) == 'array' && !isEmpty(match) || false
          result

      toBeEqual: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          actual   = objectToText(actual)   if actual?
          expected = objectToText(expected) if expected?
          result = {}
          result.pass = actual == expected
          result
          result.message = 'Expect '
          result.message += actual
          result.message += ' not' if result.pass
          result.message += ' to be equal '
          result.message += expected
          result

      toBeADslProvider: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          result = {}
          result.pass = actual? &&  type(actual) == 'object'                 &&
            arraysEqual(keysOf(actual), ['is', 'evaluate', 'name', 'func'])  &&
            type(actual.is)       == 'function'                              &&
            type(actual.evaluate) == 'function'
          result

      toBePresent: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          result = {}
          result.pass = eval("typeof #{actual} !== 'undefined' && #{actual} !== null;")
          result
