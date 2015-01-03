define(['utils'], function(_) {
  return function() {
    var args;
    args = [].slice.call(arguments);
    return {
      it: function() {
        var arg, callback, description;
        args = args.slice(0, 2);
        console.log(args);
        callback = _((function() {
          var _i, _len, _results;
          _results = [];
          for (_i = 0, _len = args.length; _i < _len; _i++) {
            arg = args[_i];
            if (typeof arg === 'function') {
              _results.push(arg);
            }
          }
          return _results;
        })()).first();
        description = _((function() {
          var _i, _len, _ref, _results;
          _ref = _(args).cropFrom(callback);
          _results = [];
          for (_i = 0, _len = _ref.length; _i < _len; _i++) {
            arg = _ref[_i];
            if (typeof arg === 'string') {
              _results.push(arg);
            }
          }
          return _results;
        })()).first() || ' ';
        return [description, callback];
      }
    };
  };
});
