describe 'JasmineSugar', ->
  subject = undefined

  beforeEach ->
    subject = new JasmineSugar()

  it 'should be defined', ->
    expect(subject).toBeDefined()

  it 'should respond to it', ->
    expect(subject.it).toBeDefined()
    expect(typeof(subject.it)).toBe 'function'

  it 'should respond to iit', ->
    expect(subject.iit).toBeDefined()
    expect(typeof(subject.iit)).toBe 'function'
