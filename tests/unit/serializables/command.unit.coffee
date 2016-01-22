describe 'Space.messaging.Command', ->

  beforeEach ->
    @command = new Space.messaging.Command

  it 'defines its EJSON type correctly', ->
    expect(@command.typeName()).to.equal 'Space.messaging.Command'
