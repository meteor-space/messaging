Space.messaging.CommandSending = {

  dependencies: {
    commandBus: 'Space.messaging.CommandBus'
  }

  send: -> @commandBus.send.apply(@commandBus, arguments)

}
