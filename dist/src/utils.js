define('utils', function() {
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
      }
    };
  };
});
