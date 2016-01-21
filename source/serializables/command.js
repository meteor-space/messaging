
Space.Struct.extend('Space.messaging.Command', {

  mixin: [Space.messaging.SerializableMixin],

  Constructor(params) {
    let data = params || {};
    if (!data) data = {};
    if (!data.timestamp) data.timestamp = new Date();
    return Space.Struct.call(this, data);
  },

  fields() {
    let fields = Space.Struct.prototype.fields.call(this);
    // Add default fields to all events
    if (!fields.targetId) fields.targetId = Match.OneOf(String, Guid);
    fields.version = Match.Optional(Match.Integer);
    fields.timestamp = Date;
    fields.meta = Match.Optional(Object);
    return fields;
  }
});
