
Space.Struct.extend('Space.messaging.Event', {

  mixin: [
    Space.messaging.Ejsonable,
    Space.messaging.Versionable
  ],

  Constructor(params) {
    let data = params || {};
    return Space.Struct.call(this, data);
  },

  fields() {
    let fields = Space.Struct.prototype.fields.call(this);
    // Add default fields to all events
    fields.schemaVersion = Match.Optional(Match.Integer);
    return fields;
  }

});
