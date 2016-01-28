Space.messaging.Versionable = {

  ERRORS: {
    dataTransformMethodMissing(version) {
      return `Missing method <transformFromVersion${version}> in Versionable class.`;
    }
  },

  schemaVersion: 1,

  onConstruction(data) {
    if (_.isObject(data) && data.schemaVersion < this.schemaVersion) {
      this._transformLegacySchema(data);
    }
  },

  _transformLegacySchema(data) {
    for (let version = data.schemaVersion; version < this.schemaVersion; version++) {
      let transformMethod = this[`transformFromVersion${version}`];
      if (transformMethod === undefined) {
        throw new Error(this.ERRORS.dataTransformMethodMissing(version));
      } else {
        transformMethod.call(this, data);
      }
    }
    data.schemaVersion = this.schemaVersion;
  }

};
