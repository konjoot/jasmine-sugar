define('CallbackWrapper', ['Context', 'CallbackFormatter'], function(_Context_, _CallbackFormatter_) {
  return function(fn, Context, CallbackFormatter) {
    if (Context == null) {
      Context = _Context_();
    }
    if (CallbackFormatter == null) {
      CallbackFormatter = _CallbackFormatter_;
    }
    this.prepareCallback = function() {
      var Formatter, char, _i, _len, _ref;
      if (fn == null) {
        return '';
      }
      Formatter = CallbackFormatter();
      _ref = fn.toString();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        char = _ref[_i];
        Formatter.push(char);
      }
      return Formatter.result();
    };
    this.run = function() {
      return this.prepareCallback().call(Context());
    };
    return this;
  };
});
