Package.describe({
  summary: 'Messaging infrastructure for Space applications.',
  name: 'space:messaging',
  version: '2.1.0',
  git: 'https://github.com/meteor-space/messaging.git'
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'underscore',
    'check',
    'ejson',
    'ecmascript',
    'fongandrew:find-and-modify@0.2.1',
    'space:base@3.1.0'
  ]);

  // SHARED
  api.addFiles([
    'source/module.coffee',
    'source/mixins/declarative-mappings.coffee',
    'source/mixins/static-handlers.coffee',
    'source/mixins/event-subscribing.coffee',
    'source/mixins/event-publishing.coffee',
    'source/mixins/command-sending.coffee',
    'source/mixins/application-helpers.coffee',
    'source/mixins/serializable.js'
  ]);

  // SERVER
  api.addFiles([
    'source/mixins/command-handling.coffee'
  ], 'server');

  // SHARED
  api.addFiles([
    'source/helpers.coffee',
    'source/value-objects/guid.coffee',
    'source/serializables/event.js',
    'source/serializables/command.js',
    'source/event_bus.coffee',
    'source/command_bus.coffee',
    'source/controller.coffee',
    'source/tracker.coffee',
    'source/publication.coffee',
    'source/api.coffee'
  ]);

});

Package.onTest(function(api) {

  api.use([
    'coffeescript',
    'underscore',
    'check',
    'ejson',
    'mongo',
    'ecmascript',
    'space:messaging',
    'practicalmeteor:munit@2.1.5',
    'space:testing@2.0.0'
  ]);

  api.addFiles([
    'tests/unit/serializable.unit.coffee',
    'tests/unit/serializables/event.unit.coffee',
    'tests/unit/event_bus.unit.coffee',
    'tests/unit/command_bus.unit.coffee',
    'tests/unit/api.unit.coffee',
    'tests/unit/value-objects/guid.unit.coffee',
    'tests/integration/controller_event_subscribing.js',
    'tests/integration/test_app.coffee'
  ]);

  api.addFiles([
    'tests/integration/controller_command_handling.js',
    'tests/integration/handling-api-messages.js'
  ], 'server');

});
