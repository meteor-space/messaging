Space.messaging.EventPublishing = {

  dependencies: {
    eventBus: 'Space.messaging.EventBus'
  }

  publish: (event) -> @eventBus.publish event

}
