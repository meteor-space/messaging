
Space.Struct.extend('Space.messaging.Event', {

  mixin: [Space.messaging.Ejsonable],

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
    fields.eventVersion = Match.Optional(Match.Integer);
    return fields;
  },

  _applyDefaultValues(data) {
    data.eventVersion = this.eventVersion;
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
