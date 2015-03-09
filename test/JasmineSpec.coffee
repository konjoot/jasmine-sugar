define ['Jasmine'], (Jasmine) ->
  describe 'Jasmine', ->
    func1   =
    func2   =
    subject = undefined

    beforeEach ->
      subject = Jasmine
      func1 = (subj)-> subj.set {one: 1}
      func2 = (subj)-> delete subj.instance.one

    it 'should set and return given value', ->
      expect(subject).toBeDefined()
      expect(subject).toHaveProperties ['set', 'instance']
      expect(subject.instance).toBeUndefined()
      expect(subject.set('test')).toBeEqual 'test'
      expect(subject.instance).toBeEqual 'test'
      expect(func1(subject)).toBeEqual {one: 1}
      expect(subject.instance).toBeEqual {one: 1}
      expect(func2(subject)).toBeEqual true
      expect(subject.instance).toBeEqual {}
