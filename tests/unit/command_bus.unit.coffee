
CommandBus = Space.messaging.CommandBus

describe 'Space.messaging.CommandBus', ->

  class TestCommand extends Space.messaging.Command
    @type 'Space.messaging.__tests__.CommandBusStubCommand'

  beforeEach ->
    @commandBus = new CommandBus()
    @testCommand = new TestCommand()
    @commandBus.meteor =
      call: sinon.spy()
      methods: sinon.spy()
      isClient: false
      isServer: true
    @commandBus.configuration = createMeteorMethods: true
    @handler = on: sinon.spy()

  it 'extends space object to be js compatible', ->
    expect(CommandBus).to.extend Space.Object

  # =================== CONFIGURATION ===================== #

  describe 'configuration', ->

    it 'registers a meteor method to accept client commands', ->

      # simulate server-side + creating meteor method
      @commandBus.onDependenciesReady()
      methods = @commandBus.meteor.methods.firstCall.args[0]

      # setup server-side handler
      @handler.allowClient = true
      @commandBus.registerHandler TestCommand, @handler

      # simulate calling the meteor method from client-side
      methods[CommandBus.METEOR_METHOD_NAME](@testCommand)
      expect(@handler.on).to.have.been.calledWithExactly @testCommand

    it 'doesnt register the meteor method if configuration says so', ->
      @commandBus.configuration = createMeteorMethods: false
      @commandBus.onDependenciesReady()
      expect(@commandBus.meteor.methods).not.to.have.been.called

    it 'throws an error when sending a client command that isnt allowed', ->
      # simulate server-side + creating meteor method
      @commandBus.onDependenciesReady()
      methods = @commandBus.meteor.methods.firstCall.args[0]

      # setup server-side handler
      @handler.allowClient = false
      @commandBus.registerHandler TestCommand, @handler

      # simulate calling the meteor method from client-side
      callMethod = => methods[CommandBus.METEOR_METHOD_NAME](@testCommand)
      expect(callMethod).to.throw Error

  # ========== REGISTERING AND SENDING COMMANDS =========== #

  describe 'registering handler and sending commands', ->

    it 'only allows one handler for a command', ->
      first = on: sinon.spy()
      second = on: sinon.spy()
      @commandBus.registerHandler TestCommand, first
      registerTwice = => @commandBus.registerHandler TestCommand, second
      expect(registerTwice).to.throw Error

    it 'allows to override an existing handler', ->
      first = on: sinon.spy()
      second = on: sinon.spy()
      @commandBus.registerHandler TestCommand, first
      @commandBus.registerHandler TestCommand, second, true
      expect(@commandBus.getHandlerFor TestCommand).to.equal second

    it 'calls the configured meteor method on client side', ->
      @commandBus.meteor.isClient = true
      callback = sinon.spy()
      @commandBus.registerHandler TestCommand, @handler
      @commandBus.send @testCommand, callback
      expect(@commandBus.meteor.call).to.have.been.calledWithExactly(
        CommandBus.METEOR_METHOD_NAME, @testCommand, callback
      )
      # Since we stubbed the meteor API this wont work during test
      expect(@handler.on).not.to.have.been.called

    it 'directly handles the command if it comes from server side', ->
      @commandBus.registerHandler TestCommand, @handler
      @commandBus.send @testCommand

      expect(@commandBus.meteor.call).not.to.have.been.called
      expect(@handler.on).to.have.been.calledWithExactly @testCommand
