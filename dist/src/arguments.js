define(['utils'], function(_) {
  return function() {
    var args;
    args = [].slice.call(arguments);
    return {
      it: function() {
        var arg;
        args = args.slice(0, 2);
        return [
          _((function() {
            var _i, _len, _results;
            _results = [];
            for (_i = 0, _len = args.length; _i < _len; _i++) {
              arg = args[_i];
              if (typeof arg === 'function') {
                _results.push(arg);
              }
            }
            return _results;
          })()).first(), _((function() {
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
          }).call(this)).first() || ' '
        ].reverse();
      }
    };
  };
});
