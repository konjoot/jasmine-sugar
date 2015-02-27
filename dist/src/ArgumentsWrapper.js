define('ArgumentsWrapper', ['Utils', 'CallbackWrapper', 'PrivateStore'], function(u, Callback, Context) {
  return function() {
    var args;
    args = [].slice.call(arguments);
    return {
      it: function() {
        var arg;
        args = args.slice(0, 2);
        return [
          u((function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = args.length; _i < _len; _i++) {
              arg = args[_i];
              if (u(arg).isAFunction()) {
                _results.push(arg);
              }
            }
            return _results;
          })()).first(), u((function() {
            var _i, _len, _ref, _results;
            _ref = u(args).cropFrom(this[0]);
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              arg = _ref[_i];
              if (u(arg).isAString()) {
                _results.push(arg);
              }
            }
            return _results;
          }).call(this)).first() || ' '
        ].reverse();
      },
      describe: function() {
        var arg, fn;
        fn = u((function() {
          var _i, _len, _ref, _results;
          _ref = args.slice(0, 2);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            arg = _ref[_i];
            if (u(arg).isAFunction()) {
              _results.push(arg);
            }
          }
          return _results;
        })()).first();
        return [
          u((function() {
            var _i, _len, _ref, _results;
            _ref = u(args.slice(0, 2)).cropFrom(fn);
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              arg = _ref[_i];
              if (u(arg).isAString()) {
                _results.push(arg);
              }
            }
            return _results;
          })()).first(), function() {
            return (new Callback(fn)).run();
          }
        ];
      },
      _describe_: function() {
        var arg;
        args = args.slice(0, 2);
        return [
          u((function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = args.length; _i < _len; _i++) {
              arg = args[_i];
              if (u(arg).isAFunction()) {
                _results.push(arg);
              }
            }
            return _results;
          })()).first(), u((function() {
            var _i, _len, _ref, _results;
            _ref = u(args).cropFrom(this[0]);
            _results = [];
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              arg = _ref[_i];
              if (u(arg).isAString()) {
                _results.push(arg);
              }
            }
            return _results;
          }).call(this)).first() || ' '
        ].reverse();
      }
    };
  };
});
