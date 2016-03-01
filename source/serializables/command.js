
Space.Struct.extend('Space.messaging.Command', {

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
    // Add default fields to all commands
    fields.schemaVersion = Match.Optional(Match.Integer);
    return fields;
  }

});
