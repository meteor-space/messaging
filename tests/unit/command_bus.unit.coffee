
CommandBus = Space.messaging.CommandBus

describe 'Space.messaging.CommandBus', ->

  class TestCommand extends Space.messaging.Command
    @type 'Space.messaging.CommandBusStubCommand'

  beforeEach ->
    @api = send: sinon.spy()
    @commandBus = new CommandBus { meteor: Meteor, api: @api }
    @testCommand = new TestCommand
    @handler = sinon.spy()

  it 'extends space object to be js compatible', ->
    expect(CommandBus).to.extend Space.Object

  describe 'registering handlers', ->

    it 'protects against multiple handler registrations for any one command', ->
      first = sinon.spy()
      second = sinon.spy()
      @commandBus.registerHandler TestCommand, first
      registerTwice = => @commandBus.registerHandler TestCommand, second
      expect(registerTwice).to.throw Error

    it 'can provide the types of commands it can handle', ->
      handler = ->
      @commandBus.registerHandler TestCommand, handler
      expect(@commandBus.getHandledCommandTypes()).to.deep.equal(
        ['Space.messaging.CommandBusStubCommand']
      )

    it 'allows handler registrations to be overridden', ->
      first = sinon.spy()
      second = sinon.spy()
      @commandBus.registerHandler TestCommand, first
      @commandBus.registerHandler TestCommand, second, true
      expect(@commandBus.getHandlerFor TestCommand).to.equal second

  describe 'sending commands', ->

    it.server 'calls the registered handler with the command', ->
      @commandBus.registerHandler TestCommand, @handler
      @commandBus.send @testCommand
      expect(@handler).to.have.been.calledWith @testCommand

    it.server 'calls the registered handler with an optional callback', ->
      @commandBus.registerHandler TestCommand, @handler
      callback = ->
      @commandBus.send @testCommand, callback
      expect(@handler).to.have.been.calledWithExactly @testCommand, callback

    it.client 'uses api.send for sending commands with optional callback', ->
      @commandBus.send @testCommand
      expect(@api.send).to.have.been.calledWith @testCommand

    it.client 'uses api.send for sending commands', ->
      callback = ->
      @commandBus.send @testCommand, callback
      expect(@api.send).to.have.been.calledWithExactly @testCommand, callback

  describe 'onSend callbacks', ->

    it.server 'calls all callbacks when sending a command', ->
      firstCallback = sinon.spy()
      secondCallback = sinon.spy()
      @commandBus.onSend firstCallback
      @commandBus.onSend secondCallback
      @commandBus.registerHandler TestCommand, @handler
      @commandBus.send @testCommand
      expect(firstCallback).to.have.been.calledWithExactly @testCommand
      expect(secondCallback).to.have.been.calledWithExactly @testCommand
