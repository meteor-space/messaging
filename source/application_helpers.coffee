
# Add basic messaging capabilities to Space applications
Space.Application.mixin {

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
    commandBus: 'Space.messaging.CommandBus'
  }

  publish: (event) -> @eventBus.publish event

  subscribeTo: (type, handler) -> @eventBus.subscribeTo type, handler

  send: (command) -> @commandBus.send command

  # Tell all sub-modules to reset their data / stop long-living observers
  reset: -> module.reset?() for _, module of @modules
}
