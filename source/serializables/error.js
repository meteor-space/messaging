// Make errors serializable
Space.Error.mixin(Space.messaging.Ejsonable);
Space.Error.type('Space.Error');

// Make errors versionable
Space.Error.mixin(Space.messaging.Versionable);
const fields = Space.Error.prototype.fields.call(this);
Space.Error.prototype.fields = function() {
  fields.schemaVersion = Match.Optional(Match.Integer);
  return fields;
};
