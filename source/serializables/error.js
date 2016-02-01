// Make errors serializable and versionable
Space.Error.mixin(Space.messaging.Ejsonable);
Space.Error.type('Space.Error');
Space.messaging.mixin(Space.messaging.Versionable)