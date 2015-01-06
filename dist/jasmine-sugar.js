;(function() {
var utils, arguments, interface, main;
utils = function (object) {
  return {
    cropFrom: function (value) {
      var delta, index;
      index = object.indexOf(value);
      delta = object.length - index;
      object.splice(index, delta);
      return object;
    },
    first: function () {
      return object[0];
    },
    isEmpty: function () {
      var val, _i, _len;
      for (_i = 0, _len = object.length; _i < _len; _i++) {
        val = object[_i];
        return false;
      }
      return true;
    },
    keys: function () {
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
arguments = function (_) {
  return function () {
    var args;
    args = [].slice.call(arguments);
    return {
      it: function () {
        var arg;
        args = args.slice(0, 2);
        return [
          _(function () {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = args.length; _i < _len; _i++) {
              arg = args[_i];
              if (typeof arg === 'function') {
                _results.push(arg);
              }
            }
            return _results;
          }()).first(),
          _(function () {
            var _i, _len, _ref, _results;
            _ref = _(args).cropFrom(this[0]);
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              arg = _ref[_i];
              if (typeof arg === 'string') {
                _results.push(arg);
              }
            }
            return _results;
          }.call(this)).first() || ' '
        ].reverse();
      }
    };
  };
}(utils);
interface = function (Jasmine, Wrapper) {
  var method, methods, _i, _len;
  if (!Jasmine) {
    return {};
  }
  if (!Wrapper) {
    return {};
  }
  methods = [
    'it',
    'iit',
    'fit',
    'xit'
  ];
  for (_i = 0, _len = methods.length; _i < _len; _i++) {
    method = methods[_i];
    this[method] = function (method) {
      return function () {
        return Jasmine[method].apply(this, Wrapper.apply(null, arguments).it());
      };
    }(method);
  }
  return this;
};
main = function (ArgumentsWrapper, Interface) {
  return {
    setup: function (context) {
      var Jasmine, Sugar, e, key;
      Jasmine = function () {
        try {
          return context.jasmine.getEnv();
        } catch (_error) {
          e = _error;
        }
      }();
      if (Jasmine == null) {
        return context;
      }
      Sugar = new Interface(Jasmine, ArgumentsWrapper);
      for (key in Sugar) {
        if (Sugar.hasOwnProperty(key) && Jasmine.hasOwnProperty(key)) {
          (function (key) {
            return context[key] = function () {
              return Sugar[key].apply(context, arguments);
            };
          }(key));
        }
      }
      return context;
    }
  };
}(arguments, interface);
(function (JasmineSugar) {
  JasmineSugar.setup(this);
  this.JasmineSugar = JasmineSugar;
  return this;
}(main));
}());