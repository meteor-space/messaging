this.MyValue = Space.messaging.Serializable.extend('MyValue', {
  fields() {
    return { name: String };
  }
});

this.MyValue.type('MyValue');

Space.messaging.define(Space.messaging.Event, {
  MyEvent: { value: MyValue },
  AnotherEvent: {}
});

Space.messaging.define(Space.messaging.Command, {
  MyCommand: { value: MyValue },
  AnotherCommand: {}
});

if (Meteor.isServer) {

  this.MyApi = Space.messaging.Api.extend('MyApi', {
    methods() {
      return [{
        // Simulate some simple method validation
        'MyCommand'(_, command) {
          if (command.value.name === 'good-value') {
            this.send(command);
          }
        },
        // Showcase that you can also call your methods "like normal"
        'UncheckedMethod'(_, id) {
          this.send(new AnotherCommand({
            targetId: id
          }));
        }
      }];
    }
  });

  this.MyCommandHandler = Space.Object.extend({
    mixin: [
      Space.messaging.CommandHandling
    ],
    commandHandlers() {
      return [{
        'MyCommand'() {},
        'AnotherCommand'() {}
      }];
    }
  });

  this.MyApp = Space.Application.extend({
    requiredModules: ['Space.messaging'],
    singletons: ['MyApi', 'MyCommandHandler']
  });

}

