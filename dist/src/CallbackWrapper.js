define('CallbackWrapper', ['Store', 'Context', 'Jasmine', 'Evaluator', 'CallbackFormatter'], function(_Store_, _Context_, _Jasmine_, _Evaluator_, _CallbackFormatter_) {
  return function(fn, Store, Context, Jasmine, Evaluator, CallbackFormatter) {
    var evaluator;
    if (Store == null) {
      Store = _Store_;
    }
    if (Context == null) {
      Context = _Context_;
    }
    if (Jasmine == null) {
      Jasmine = _Jasmine_;
    }
    if (Evaluator == null) {
      Evaluator = _Evaluator_;
    }
    if (CallbackFormatter == null) {
      CallbackFormatter = _CallbackFormatter_;
    }
    evaluator = new Evaluator();
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
      return eval("(" + (Formatter.result()) + ");");
    };
    this.run = function() {
      return this.prepareCallback().call(Context.get());
    };
    return this;
  };
});
