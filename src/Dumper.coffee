define 'Dumper', ->
  (size, dump)->
    size = 9 unless size?
    dump = [] unless dump?

    do ->
      {
        push: (val)->
          dump.shift() if dump.push(val) > size

        buffer: (index)->
          return dump.join('') unless index?
          dump.join('')[index]
      }
