
Command = Space.messaging.Command

describe 'Space.messaging.Command', ->

  beforeEach ->
    @command = new Command

  it "is Ejsonable", ->
    expect(Command.hasMixin(Space.messaging.Ejsonable)).to.be.true

  it "is Versionable", ->
    expect(Command.hasMixin(Space.messaging.Versionable)).to.be.true

  it 'defines its EJSON type correctly', ->
    expect(@command.typeName()).to.equal 'Space.messaging.Command'
