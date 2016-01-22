
Space.Struct.extend('Space.messaging.Event', {

  mixin: [Space.messaging.Ejsonable],

  eventVersion: 1,

  Constructor(params) {
    let data = params || {};
    this._migrateToLatestVersion(data);
    return Space.Struct.call(this, data);
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
