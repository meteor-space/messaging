
Space.Struct.extend('Space.messaging.Event', {

  mixin: [Space.messaging.SerializableMixin],

  eventVersion: 1,

  Constructor(params) {
    let data = params || {};
    this._migrateToLatestVersion(data);
    this._applyDefaultValues(data);
    return Space.Struct.call(this, data);
  },

  fields() {
    let fields = Space.Struct.prototype.fields.call(this);
    // Add default fields to all events
    if (!fields.sourceId) fields.sourceId = Match.Optional(Match.OneOf(String, Guid));
    fields.eventVersion = Match.Optional(Match.Integer);
    fields.version = Match.Optional(Match.Integer);
    fields.timestamp = Date;
    fields.meta = Match.Optional(Object);
    return fields;
  },

  _applyDefaultValues(data) {
    data.eventVersion = this.eventVersion;
    if (!data.timestamp) data.timestamp = new Date();
  },

  _migrateToLatestVersion(data) {
    let eventVersion = data.eventVersion;
    if (!eventVersion || eventVersion === this.eventVersion) return;
    for (let version = eventVersion; version < this.eventVersion; version++) {
      let migrateMethod = this[`migrateFromVersion${version}`];
      if (migrateMethod !== undefined) migrateMethod.call(this, data);
    }
  }
});
