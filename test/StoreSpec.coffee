define ['Store'], (Store)->
  describe 'Store', ->
    object  =
    subject =
    funcOne =
    funcTwo = undefined

    beforeEach ->
      object = {}
      subject = Store(object)
      funcOne = (store)-> store.one = 1
      funcTwo = (store)-> store.two = store.one + 1

    it 'changing subject should affect object', ->
      subject.one = 1
      subject.two = 2
      expect(object).toBeEqual {one: 1, two: 2}
      delete subject.one
      subject.two = 3
      expect(object).toBeEqual {two: 3}
      delete subject.two
      expect(object).toBeEmpty()
      funcOne(subject)
      expect(object).toBeEqual {one: 1}
      funcTwo(subject)
      expect(object).toBeEqual {one: 1, two: 2}



