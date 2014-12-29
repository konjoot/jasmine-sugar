describe 'JasmineSugar.Interface', ->
  subject = undefined

  beforeEach ->
    subject = new JasmineSugar.Arguments()

  it 'should be defined', ->
    expect(subject).toBeDefined()
