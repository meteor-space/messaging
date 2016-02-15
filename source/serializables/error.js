// Make errors serializable
Space.Error.mixin(Space.messaging.Ejsonable);
Space.Error.type('Space.Error');

// Make errors versionable
Space.Error.mixin(Space.messaging.Versionable);
Space.Error.prototype.fields = _.wrap(Space.Error.prototype.fields,
  function(original) {
    const fields = original.call(this);
    fields.schemaVersion = Match.Optional(Match.Integer);
    return fields;
  }
);
