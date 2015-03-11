define 'Dumper', ->
  (size, dump)->
    size = 9 unless size?
    dump = [] unless dump?

    do ->
      {
        push: (val)-> dump.shift() if dump.push(val) > size

        buffer: ()-> dump.join('')
      }
