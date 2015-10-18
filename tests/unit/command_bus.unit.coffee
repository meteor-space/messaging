
CommandBus = Space.messaging.CommandBus

describe 'Space.messaging.CommandBus', ->

  class TestCommand extends Space.messaging.Command
    @type 'Space.messaging.CommandBusStubCommand'

  beforeEach ->
    @api = send: sinon.spy()
    @commandBus = new CommandBus { meteor: Meteor, api: @api }
    @testCommand = new TestCommand()
    @handler = sinon.spy()

  it 'extends space object to be js compatible', ->
    expect(CommandBus).to.extend Space.Object

  describe 'registering handlers', ->

    it 'only allows one handler for a command', ->
      first = sinon.spy()
      second = sinon.spy()
      @commandBus.registerHandler TestCommand, first
      registerTwice = => @commandBus.registerHandler TestCommand, second
      expect(registerTwice).to.throw Error

    it 'allows to override an existing handler', ->
      first = sinon.spy()
      second = sinon.spy()
      @commandBus.registerHandler TestCommand, first
      @commandBus.registerHandler TestCommand, second, true
      expect(@commandBus.getHandlerFor TestCommand).to.equal second

  describe 'sending commands', ->

    it.server 'calls the registered handler with the command', ->
      @commandBus.registerHandler TestCommand, @handler
      @commandBus.send @testCommand
      expect(@handler).to.have.been.calledWithExactly @testCommand

    it.client 'sends the command to the server via the api', ->
      callback = ->
      @commandBus.send @testCommand, callback
      expect(@api.send).to.have.been.calledWithExactly @testCommand, callback
