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

      toHaveProperties: (util, customEqualityTesters)->
        return compare: (actual, expected)->
          result = {}
          result.pass = arraysEqual(keysOf(actual), expected) if expected?
          result.pass ||= keysOf(actual).length > 0
          result
