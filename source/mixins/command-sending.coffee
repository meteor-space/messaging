Space.messaging.CommandSending = {

  Dependencies: {
    commandBus: 'Space.messaging.CommandBus'
  }

  send: (command) -> @commandBus.send command

}
