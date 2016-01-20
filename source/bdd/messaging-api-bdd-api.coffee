# BDD api for testing Space.messaging.Api

Space.Module.registerBddApi (app, systemUnderTest) ->
  if !Space.messaging? then return
  return new ApiTest(app) if isSubclassOf(systemUnderTest, Space.messaging.Api)

class ApiTest

  constructor: (@_app) ->
    @_app.reset()
    @_app.start()
    @_apiArgs = []
    @_sentCommands = []
    @_expectedCommands = []
    @_commandBus = @_app.injector.get 'Space.messaging.CommandBus'

  send: (command) ->
    @_apiArgs = [command]
    return this

  call: (@_apiArgs...) -> return this

  expect: (expectedCommands) ->
    if _.isFunction(expectedCommands)
      @_expectedCommands = expectedCommands()
    else
      @_expectedCommands = expectedCommands
    @_test = =>
      @_callApi()
      expect(@_sentCommands).containArrayOfStructs @_expectedCommands
    @_run()

  expectToFailWith: (expectedError) ->
    @_test = => expect(@_callApi).to.throw expectedError.message
    @_run()

  _run: ->
    try
      @_commandBus.onSend (command) => @_sentCommands.push(command)
      @_test()
    finally
      @_cleanup()

  _cleanup: -> @_app.stop()

  _callApi: =>
    if @_apiArgs.length is 1
      Space.messaging.Api.send(@_apiArgs[0]) # it's a command
    else
      Meteor.call.apply(null, @_apiArgs)
