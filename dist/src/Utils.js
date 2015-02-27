define('Utils', function() {
  var objectToText, type;
  type = function(obj) {
    var classToType;
    if (obj === void 0 || obj === null) {
      return String(obj);
    }
    classToType = {
      '[object Boolean]': 'boolean',
      '[object Number]': 'number',
      '[object String]': 'string',
      '[object Function]': 'function',
      '[object Array]': 'array',
      '[object Date]': 'date',
      '[object RegExp]': 'regexp',
      '[object Object]': 'object',
      '[object Null]': 'null'
    };
    return classToType[Object.prototype.toString.call(obj)];
  };
  objectToText = function(obj) {
    var prop, strArray, tmpArray, _i, _len;
    strArray = [];
    switch (type(obj)) {
      case 'object':
        strArray.push("{");
        tmpArray = [];
        for (prop in obj) {
          tmpArray.push("" + prop + ": " + (objectToText(obj[prop])));
        }
        strArray.push(tmpArray.join());
        strArray.push("}");
        break;
      case 'array':
        strArray.push("[");
        tmpArray = [];
        for (_i = 0, _len = obj.length; _i < _len; _i++) {
          prop = obj[_i];
          tmpArray.push(objectToText(prop));
        }
        strArray.push(tmpArray.join());
        strArray.push("]");
        break;
      case 'function':
        strArray.push("" + (obj.toString()));
        break;
      default:
        strArray.push(JSON.stringify(obj));
    }
    return strArray.join('');
  };
  return function(object) {
    return {
      cropFrom: function(value) {
        var delta, index;
        index = object.indexOf(value);
        delta = object.length - index;
        object.splice(index, delta);
        return object;
      },
      first: function() {
        return object[0];
      },
      isEmpty: function() {
        var val, _i, _len;
        for (_i = 0, _len = object.length; _i < _len; _i++) {
          val = object[_i];
          return false;
        }
        return true;
      },
      keys: function() {
        var key, _results;
        _results = [];
        for (key in object) {
          if (object.hasOwnProperty(key)) {
            _results.push(key);
          }
        }
        return _results;
      },
      isAFunction: function() {
        return (object != null) && type(object) === 'function';
      },
      isAnObject: function() {
        return (object != null) && type(object) === 'object';
      },
      isAString: function() {
        return (object != null) && type(object) === 'string';
      },
      toString: function() {
        switch (type(object)) {
          case 'function':
            return "(" + (object.toString()) + ")";
          case 'object':
          case 'array':
            return "(" + (objectToText(object)) + ")";
          default:
            return JSON.stringify(object);
        }
      }
    };
  };
});
