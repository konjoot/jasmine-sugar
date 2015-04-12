define ['EventMachine'], (EventMachine)->
  fdescribe 'EventMachine', ->
    subject = undefined

    beforeEach ->
      subject = EventMachine()

    it 'should be defined', ->
      expect(subject).toBeDefined()

    it 'should be a function', ->
      expect(subject).toBeAFunction()

    it 'should have triggers storage in closure', ->
      expect(EventMachine('triggers')()).toBeAnObject()
