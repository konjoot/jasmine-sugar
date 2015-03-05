define 'Dumper', ->
  (size = 9)->
    dump = []

    {
      push: (val)->
        dump.shift() if dump.push(val) > size

      buffer: (index)->
        return dump.join('') unless index?
        dump.join('')[index]
    }
