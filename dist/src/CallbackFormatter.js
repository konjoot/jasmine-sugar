define('CallbackFormatter', ['Store', 'Evaluator', 'Jasmine', 'DslFactory', 'Analizer'], function(_Store_, _Evaluator_, _Jasmine_, _DslFactory_, _Analizer_) {
  return function(Store, Evaluator, Jasmine, DslFactory, Analizer) {
    var add, analize, beginWrap, clearLine, describeReplacer, endWrap, line, mainReplacer, offset, pushToResult, result_string, returnCallback, status, updateResult;
    if (Store == null) {
      Store = _Store_();
    }
    if (Evaluator == null) {
      Evaluator = _Evaluator_();
    }
    if (Jasmine == null) {
      Jasmine = _Jasmine_;
    }
    if (DslFactory == null) {
      DslFactory = _DslFactory_;
    }
    if (Analizer == null) {
      Analizer = _Analizer_();
    }
    line = [];
    offset = '';
    status = Analizer;
    result_string = [];
    clearLine = function() {
      return line = [];
    };
    mainReplacer = function(match, p1, p2) {
      if (!((p1 != null) && (p2 != null))) {
        return;
      }
      offset = p1;
      return ("" + p1 + "var " + p2 + " = void 0;\n") + ("" + p1 + "var _" + p2 + "_ = " + (DslFactory.source(offset, p2))) + match.replace(p2, "_" + p2 + "_");
    };
    describeReplacer = function(match, p1) {
      if (p1 != null) {
        return match.replace(p1, "_" + p1 + "_");
      }
    };
    updateResult = function() {
      if (status.endOfLine != null) {
        return pushToResult();
      }
    };
    pushToResult = function() {
      var joined_line;
      joined_line = line.join('');
      joined_line = joined_line.replace(/(\s*)(\w*)\.is\(.*/g, mainReplacer);
      joined_line = joined_line.replace(/.*(describe)\(.*/g, describeReplacer);
      joined_line = joined_line.replace(/.*([xfd]{1}describe)\(.*/g, describeReplacer);
      return result_string.push(joined_line) && clearLine();
    };
    returnCallback = function() {
      return eval("(" + (result_string.join('')) + ");");
    };
    endWrap = function() {
      if (status.endMatched == null) {
        return;
      }
      return line.push('; }');
    };
    beginWrap = function() {
      if (status.beginMatched == null) {
        return;
      }
      return line.push('function() { return ');
    };
    add = function(char) {
      return line.push(char);
    };
    analize = function(char) {
      return Analizer.push(char);
    };
    return {
      push: function(char) {
        analize(char);
        endWrap();
        add(char);
        beginWrap();
        return updateResult();
      },
      result: function() {
        pushToResult();
        return returnCallback();
      }
    };
  };
});
