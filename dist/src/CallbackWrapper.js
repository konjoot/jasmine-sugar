define('CallbackWrapper', ['Store', 'Context', 'Jasmine', 'Evaluator', 'ContextFactory'], function(_Store_, _Context_, _Jasmine_, _Evaluator_, _ContextFactory_) {
  return function(fn, Store, Context, Jasmine, Evaluator, ContextFactory) {
    var Dump, evaluator;
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
    if (ContextFactory == null) {
      ContextFactory = _ContextFactory_;
    }
    evaluator = new Evaluator();
    Dump = function(size) {
      var dump;
      if (size == null) {
        size = 9;
      }
      dump = [];
      return {
        push: function(val) {
          if (dump.push(val) > size) {
            return dump.shift();
          }
        },
        buffer: function(index) {
          if (index == null) {
            return dump.join('');
          }
          return dump.join('')[index];
        }
      };
    };
    this.prepareCallback = function() {
      var Result, ResultFormatter, analize, beginMatched, beginWrap, callbackBegins, char, dump, endMatched, endOfLine, endWrap, inCallback, inDSLParams, inParenthesis, inString, parentheses, strings, _i, _len, _ref;
      inString = endOfLine = endMatched = inCallback = inDSLParams = beginMatched = inParenthesis = callbackBegins = void 0;
      parentheses = [];
      strings = [];
      dump = Dump();
      ResultFormatter = function() {
        var clearLine, describeReplacer, factoryReplacer, line, mainReplacer, offset, pushToResult, result_string;
        result_string = [];
        line = [];
        offset = '';
        clearLine = function() {
          return line = [];
        };
        factoryReplacer = function(match, p1) {
          if (p1 == null) {
            return;
          }
          if (p1.length < 1) {
            return match;
          }
          return match.replace(p1, p1 + offset);
        };
        mainReplacer = function(match, p1, p2) {
          if (!((p1 != null) && (p2 != null))) {
            return;
          }
          offset = p1;
          return ("" + p1 + "var " + p2 + " = void 0;\n") + ("" + p1 + "var _" + p2 + "_ = new (" + (ContextFactory.toString().replace(/(\s*){1}.*/g, factoryReplacer)) + ")('" + p2 + "', evaluator, Jasmine, Store);\n") + match.replace(p2, "_" + p2 + "_");
        };
        describeReplacer = function(match, p1) {
          if (p1 != null) {
            return match.replace(p1, "_" + p1 + "_");
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
        return {
          push: function(char) {
            line.push(char);
            if (endOfLine != null) {
              return pushToResult();
            }
          },
          result: function() {
            pushToResult();
            return result_string.join('');
          }
        };
      };
      analize = function(char) {
        dump.push(char);
        if ((inString != null) && inString === false) {
          inString = void 0;
        }
        if (endOfLine != null) {
          endOfLine = void 0;
        }
        if (endMatched != null) {
          endMatched = void 0;
        }
        if ((inDSLParams != null) && inDSLParams === false) {
          inDSLParams = void 0;
        }
        if (beginMatched != null) {
          beginMatched = void 0;
        }
        if (callbackBegins != null) {
          callbackBegins = void 0;
        }
        switch (false) {
          case !(dump.buffer() === 'tion () {' && (inCallback == null)):
            return callbackBegins = inCallback = true;
          case !(char === '(' && (inDSLParams != null) && (inString == null)):
            return parentheses.push(char);
          case !(char === ')' && (inDSLParams != null) && (inString == null)):
            inDSLParams = parentheses.pop();
            if (inDSLParams == null) {
              return endMatched = true;
            }
            break;
          case !(dump.buffer().substring(8) === "\n" && (inString == null)):
            return endOfLine = true;
          case !(dump.buffer().substring(5) === '.is(' && (typeof inDescribe === "undefined" || inDescribe === null)):
            return inDSLParams = beginMatched = true;
          case !((char.match(/'|"/) != null) && (inDSLParams != null) && strings.indexOf(char) < 0 && !dump.buffer(7) === "\\"):
            strings.push(char);
            return inString = true;
          case !((char.match(/'|"/) != null) && (inDSLParams != null) && !dump.buffer(7) === "\\"):
            strings.splice(strings.indexOf(char), 1);
            return inString = strings.length > 0;
        }
      };
      if (fn == null) {
        return '';
      }
      Result = ResultFormatter();
      beginWrap = 'function() { return ';
      endWrap = '; }';
      _ref = fn.toString();
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        char = _ref[_i];
        analize(char);
        if (endMatched != null) {
          Result.push(endWrap);
        }
        Result.push(char);
        if (beginMatched != null) {
          Result.push(beginWrap);
        }
      }
      return eval("(" + (Result.result()) + ");");
    };
    this.run = function() {
      return this.prepareCallback().call(Context.get());
    };
    return this;
  };
});
