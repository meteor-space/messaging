Space.messaging.EventPublishing = {

  Dependencies: {
    eventBus: 'Space.messaging.EventBus'
  }
  
  publish: (event) -> @eventBus.publish event

}
