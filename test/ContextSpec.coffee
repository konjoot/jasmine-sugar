define ['Context'], (Context)->
  describe 'Context', ->
    func1   =
    func2   =
    subject = undefined

    beforeEach ->
      subject = Context()
      func1 = (value)-> value(';-)')
      func2 = (value)-> value()

    it 'should can set and get given value', ->
      expect(subject()).toBeUndefined()
      expect(subject('test')).toBeEqual 'test'
      expect(subject()).toBeEqual 'test'
      expect(subject([1,2,3])).toBeEqual [1,2,3]
      expect(subject()).toBeEqual [1,2,3]
      expect(func1(subject)).toBeEqual ';-)'
      expect(func2(subject)).toBeEqual ';-)'




