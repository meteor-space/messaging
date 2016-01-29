Space.messaging.CommandHandling = {

  dependencies: {
    commandBus: 'Space.messaging.CommandBus'
  },

  ERRORS: {
    noCommandHandlersDefined() {
      return 'Please define a ::commandHandlers method that returns array of mappings.';
    },
    invalidCommandType(commandType) {
      return `Cannot register command handler for ${commandType}`;
    },
    invalidCommandHandler() {
      return "You have to provide a command handler function.";
    },
    noCommandHandlerFound(typeName) {
      return `No command handler found for <${typeName}>`;
    }
  },

  _commandHandlers: null,

  onConstruction() {
    if (this._commandHandlers === null) {
      this._commandHandlers = {};
    }
  },

  onDependenciesReady() {
    this._setupCommandHandling();
  },

  canHandleCommand(command) {
    return this._getCommandHandlerFor(command) !== undefined;
  },

  register(commandType, handler) {
    if (!commandType) {
      throw new Error(this.ERRORS.invalidCommandType(commandType));
    } else if (!handler) {
      throw new Error(this.ERRORS.invalidCommandHandler());
    }
    this._commandHandlers[commandType.toString()] = handler;
    this.commandBus.registerHandler(commandType, this.underscore.bind(handler, this));
  },

  handle(command) {
    let handler = this._getCommandHandlerFor(command);
    if (!handler) {
      throw new Error(this.ERRORS.noCommandHandlerFound(command.typeName()));
    }
    handler.call(this, command);
  },

  _setupCommandHandling() {
    if (!this.underscore.isFunction(this.commandHandlers)) return;
    this._setupDeclarativeMappings('commandHandlers', (handler, commandType) => {
      this.register(commandType, handler);
    });
  },

  _getCommandHandlerFor(command) {
    return this._commandHandlers[command.typeName()];
  }
};

_.deepExtend(Space.messaging.CommandHandling, Space.messaging.DeclarativeMappings);
