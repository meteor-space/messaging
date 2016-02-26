Package.describe({
  summary: 'Messaging infrastructure for Space applications.',
  name: 'space:messaging',
  version: '3.1.1',
  git: 'https://github.com/meteor-space/messaging.git'
});

Package.onUse(function(api) {

  api.versionsFrom('1.2.0.1');

  api.use([
    'coffeescript',
    'underscore',
    'check',
    'ejson',
    'ecmascript',
    'fongandrew:find-and-modify@0.2.1',
    'space:base@4.1.2'
  ]);

  // SHARED
  api.addFiles([
    'source/module.coffee',
    'source/mixins/declarative-mappings.js',
    'source/mixins/static-handlers.coffee',
    'source/mixins/event-subscribing.js',
    'source/mixins/event-publishing.coffee',
    'source/mixins/command-sending.coffee',
    'source/mixins/application-helpers.coffee',
    'source/mixins/ejsonable.js',
    'source/mixins/versionable.js'
  ]);

  // SERVER
  api.addFiles([
    'source/mixins/command-handling.js'
  ], 'server');

  // SHARED
  api.addFiles([
    'source/helpers.coffee',
    'source/value-objects/guid.coffee',
    'source/serializables/event.js',
    'source/serializables/command.js',
    'source/serializables/error.js',
    'source/event_bus.coffee',
    'source/command_bus.coffee',
    'source/controller.js',
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
    'space:testing@3.0.2',
    'space:testing-messaging@3.0.1',
    'space:messaging',
    'practicalmeteor:munit@2.1.5'
  ]);

  api.addFiles([
    'tests/unit/serializable.unit.coffee',
    'tests/unit/serializables/event.unit.coffee',
    'tests/unit/serializables/command.unit.coffee',
    'tests/unit/serializables/space-error.tests.js',
    'tests/unit/event_bus.unit.coffee',
    'tests/unit/command_bus.unit.coffee',
    'tests/unit/api.unit.coffee',
    'tests/unit/value-objects/guid.unit.coffee',
    'tests/unit/helpers.tests.js',
    'tests/unit/mixins/versionable.tests.js',
    'tests/unit/mixins/event-subscribing.tests.js',
    'tests/integration/controller_event_subscribing.js',
    'tests/integration/test-app.js'
  ]);

  api.addFiles([
    'tests/integration/controller_command_handling.js',
    'tests/integration/handling-api-messages.js',
    'tests/unit/mixins/command-handling.tests.js'
  ], 'server');

});
