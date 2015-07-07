Package.describe({
  summary: 'Messaging infrastructure for Space applications.',
  name: 'space:messaging',
  version: '1.4.2',
  git: 'https://github.com/CodeAdventure/space-messaging.git',
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'underscore',
    'check',
    'ejson',
    'space:base@2.1.0'
  ]);

  api.addFiles([
    'source/module.coffee',
    'source/serializable.coffee',
    'source/helpers.coffee',
    'source/event.coffee',
    'source/event_bus.coffee',
    'source/command.coffee',
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
    'underscore',
    'space:messaging',
    'practicalmeteor:munit@2.1.4',
    'space:testing@1.3.0'
  ]);

  api.addFiles([
    'tests/unit/serializable.unit.coffee',
    'tests/unit/event.unit.coffee',
    'tests/unit/event_bus.unit.coffee',
    'tests/unit/command_bus.unit.coffee',
    'tests/unit/controller.unit.coffee',
    'tests/integration/test_app.coffee',
    'tests/integration/integration_tests.coffee',
    'tests/unit/api.unit.coffee',
  ]);

});
