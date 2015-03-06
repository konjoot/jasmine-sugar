define ['Store'], (Store)->
  describe 'Store', ->
    object  =
    subject = undefined

    beforeEach ->
      object = {}
      subject = Store(object)

    it 'should be defined', ->
      expect(subject).toBeDefined()

    it 'changing subject should affect object', ->
      subject.one = 1
      subject.two = 2
      expect(object).toBeEqual {one: 1, two: 2}
      delete subject.one
      subject.two = 3
      expect(object).toBeEqual {two: 3}

    describe 'work with outer functions', ->
      funcOne =
      funcTwo = undefined

      beforeEach ->
        funcOne = (store)->
          store.one = 1

        funcTwo = (store)->
          store.two = store.one + 1

      it 'should distribute private store', ->
        expect(object).toBeEmpty()
        funcOne(subject)
        expect(object).toBeEqual {one: 1}
        funcTwo(subject)
        expect(object).toBeEqual {one: 1, two: 2}



