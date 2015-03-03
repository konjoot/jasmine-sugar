define('CallbackFormatter', ['ContextFactory'], function(_ContextFactory_) {
  return function(ContextFactory) {
    var Dump, analize, beginMatched, beginWrap, callbackBegins, clearLine, describeReplacer, dump, endMatched, endOfLine, endWrap, factoryReplacer, inCallback, inDSLParams, inParenthesis, inString, line, mainReplacer, offset, parentheses, pushToResult, result_string, strings;
    if (ContextFactory == null) {
      ContextFactory = _ContextFactory_;
    }
    result_string = [];
    line = [];
    offset = '';
    inString = endOfLine = endMatched = inCallback = inDSLParams = beginMatched = inParenthesis = callbackBegins = void 0;
    parentheses = [];
    strings = [];
    beginWrap = 'function() { return ';
    endWrap = '; }';
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
    dump = Dump();
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
        analize(char);
        if (endMatched != null) {
          line.push(endWrap);
        }
        line.push(char);
        if (beginMatched != null) {
          line.push(beginWrap);
        }
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
});
