Package.describe({
  summary: 'Rock solid messaging infrastructure for Meteor.',
  name: 'space:messaging',
  version: '0.1.0',
  git: 'https://github.com/CodeAdventure/space-messaging.git',
});

Package.onUse(function(api) {

  api.versionsFrom("METEOR@1.0");

  api.use([
    'coffeescript',
    'ejson',
    'space:base@1.2.8'
  ]);

  api.addFiles([
    'source/module.coffee',
    'source/serializable.coffee',
    'source/event.coffee',
    'source/command.coffee',
    'source/event_bus.coffee',
    'source/controller.coffee',
  ]);

});

Package.onTest(function(api) {

  api.use([
    'coffeescript',
    'space:messaging',
    'practicalmeteor:munit@2.0.2',
    'space:testing@1.3.0'
  ]);

  api.addFiles([
    'tests/serializable.unit.coffee',
    'tests/event.unit.coffee',
    'tests/event_bus.unit.coffee',
    'tests/controller.unit.coffee',
  ], 'server');

});
