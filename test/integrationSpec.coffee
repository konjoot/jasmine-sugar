define ['main'], (JasmineSugar) ->
  describe 'integration tests with JasmineEmulator(JE)', ->
    context = undefined

    beforeEach ->
      Jasmine = getEnv: -> JE
      context = jasmine: Jasmine

      JasmineSugar.setup(context)

    it 'with plain type one declaration', ->
      jasmine = JE

      jasmine.describe 'test', ->

        context.set ->
          collection.is 'something'

        context.it -> # using JasmineSugar it method )
          # jasmine it context
          expect(collection).toBeDefined()
          expect(collection).toEqual 'something'

        # jasmine describe context
        expect(collection?).toBeFalsy()

      # outer context before tests run
      expect(collection?).toBeFalsy()

      jasmine.run()

      # outer context after tests run
      expect(collection?).toBeFalsy()

    it 'with plain type multiple declarations', ->
      jasmine = JE

      jasmine.describe 'test', ->

        context.set ->
          collection.is 'something'
          another.is    'something else'

        context.it -> # using JasmineSugar it method )
          # jasmine it context
          expect(collection).toBeDefined()
          expect(collection).toEqual 'something'
          expect(another).toBeDefined()
          expect(another).toEqual 'something else'

        # jasmine describe context
        expect(collection?).toBeFalsy()
        expect(another?).toBeFalsy()

      # outer context before tests run
      expect(collection?).toBeFalsy()
      expect(another?).toBeFalsy()

      jasmine.run()

      # outer context after tests run
      expect(collection?).toBeFalsy()
      expect(another?).toBeFalsy()

    xit 'with plain type multiple declarations when collide with outer variables'

    xit 'with plain type multiple declarations when collide with context methods names'

    xit 'with function one declaration'

    xit 'with function multiple declarations'

    xit 'with function multiple declarations when collide with outer variables'

    xit 'with function multiple declarations when collide with context methods names'

# todo: specs that spies beforeEach and afterEach calls - in callbackFactorySpec
# todo: specs that checks Store changes between beforeEach and afterEach calls - in callbackFactorySpec
#   for that case may be suitable to use in callbackFactorySpec JE
#   and in JE implement methods which allows to separately run befores, tests and afters
# todo: specs with multiple it calls in one describe
# todo: rewrite integration tests:
#   - move JE describe in beforeEach
#   - retrieve needed vars from multiple places in JE's describe
#   - and then test this in it blocks