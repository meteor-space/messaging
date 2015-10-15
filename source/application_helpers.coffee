
# Add basic messaging capabilities to Space applications
Space.Application.mixin {

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'
  }

  publish: -> @eventBus.publish.apply(@eventBus, arguments)

  subscribeTo: (type, handler) -> @eventBus.subscribeTo.apply(@eventBus, arguments)

  send: (command) -> @commandBus.send.apply(@commandBus, arguments)

  # Tell all sub-modules to reset their data / stop long-living observers
  reset: -> module.reset?() for _, module of @modules
}
