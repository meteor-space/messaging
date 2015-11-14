Space.messaging.CommandSending = {

  dependencies: {
    commandBus: 'Space.messaging.CommandBus'
  }

  send: (command) -> @commandBus.send command

}
