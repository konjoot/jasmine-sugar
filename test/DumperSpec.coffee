define ['Dumper'], (Dumper)->
  describe 'Dumper', ->
    buffer  =
    subject = undefined

    pushSpecs =
      a: {value: undefined, buffer: ['a']     },
      b: {value: undefined, buffer: ['a', 'b']},
      c: {value: 'a',       buffer: ['b', 'c']}

    beforeEach ->
      buffer = []
      subject = Dumper(2, buffer)

    it 'interface', ->
      expect(subject).toHaveProperties ['push', 'buffer']

    it 'behaviour', ->
      for val, result of pushSpecs
        expect(subject.push(val)).toBeEqual result.value
        expect(buffer).toBeEqual result.buffer
        expect(subject.buffer()).toBeEqual result.buffer.join('')

    describe 'defaults', ->
      beforeEach ->
        subject = Dumper()

        pushSpecs =
          a: {value: undefined, buffer: 'a'        },
          b: {value: undefined, buffer: 'ab'       },
          c: {value: undefined, buffer: 'abc'      },
          d: {value: undefined, buffer: 'abcd'     },
          e: {value: undefined, buffer: 'abcde'    },
          f: {value: undefined, buffer: 'abcdef'   },
          h: {value: undefined, buffer: 'abcdefh'  },
          j: {value: undefined, buffer: 'abcdefhj' },
          k: {value: undefined, buffer: 'abcdefhjk'},
          l: {value: 'a',       buffer: 'bcdefhjkl'}

      it 'buffer size == 9 elements', ->
        for val, result of pushSpecs
          expect(subject.push(val)).toBeEqual result.value
          expect(subject.buffer()).toBeEqual result.buffer
