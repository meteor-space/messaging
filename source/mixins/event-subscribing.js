Space.messaging.EventSubscribing = {

  dependencies: {
    eventBus: 'Space.messaging.EventBus',
    meteor: 'Meteor'
  },

  _eventHandlers: null,

  onConstruction() {
    console.log('in')
    if (this._eventHandlers === null) {
      this._eventHandlers = {};
    }
  },

  onDependenciesReady() {
    this._setupEventSubscribing();
  },

  canHandleEvent(event) {
    return this._getEventHandlerFor(event) !== undefined;
  },

  subscribe(eventType, handler) {
    if (!eventType) {
      throw new Error(`Cannot register event handler for ${eventType}`);
    } else if (!handler) {
      throw new Error("You have to provide a handler function.");
    }
    this._eventHandlers[eventType.toString()] = handler;
    this.eventBus.subscribeTo(eventType, this._bindEventHandler(handler));
  },

  on(event) {
    let handler = this._getEventHandlerFor(event);
    if (!handler) {
      throw new Error(`No event handler found for <${event.typeName()}>`);
    }
    handler.call(this, event);
  },

  _setupEventSubscribing() {
    if (!this.eventSubscriptions) return;
    this._setupDeclarativeMappings('eventSubscriptions', (handler, eventType) => {
      this.subscribe(eventType, handler);
    });
  },

  /**
   * All event handlers are bound to the meteor environment by default
   * so that the application code can mainly stay clear of having to
   * deal with these things.
   */
  _bindEventHandler(handler) {
    if (this.meteor.isServer) {
      return this.meteor.bindEnvironment(handler, this._onException, this);
    } else {
      return this.underscore.bind(handler, this);
    }
  },

  _getEventHandlerFor(event) {
    return this._eventHandlers[event.typeName()];
  },

  _onException(error) { throw error; }

};

_.deepExtend(Space.messaging.EventSubscribing, Space.messaging.DeclarativeMappings);
