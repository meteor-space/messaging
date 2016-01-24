Space.messaging.Versionable = {

  schemaVersion: 1,

  onConstruction(data) {
    if (_.isObject(data)) this._migrateToLatestVersion(data);
  },

  _migrateToLatestVersion(data) {
    let schemaVersion = data.schemaVersion;
    if (!schemaVersion || schemaVersion === this.schemaVersion) return;
    for (let version = schemaVersion; version < this.schemaVersion; version++) {
      let migrateMethod = this[`migrateFromVersion${version}`];
      if (migrateMethod !== undefined) migrateMethod.call(this, data);
    }
    data.schemaVersion = this.schemaVersion;
  }

};
