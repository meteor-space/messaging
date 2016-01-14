
// ========= HELPERS ========== //

let generateTypeNameMethod = function(typeName) {
  return function() {
    return typeName;
  };
};

let fromJSONValueFunction = function(Class, json) {
  // Parse all fields that are set in the given json
  for (let field in Class.prototype.fields()) {
    if (json[field]) {
      json[field] = EJSON.fromJSONValue(json[field]);
    }
  }
  return new Class(json);
};

Space.messaging.SerializableMixin = {

  statics: {

    // Mark this class as serializable
    isSerializable: true,

    // Add unique type for serialization
    type(name) {
      Space.Object.type.call(this, name);
      this.prototype.typeName = this.toString = generateTypeNameMethod(name);
      EJSON.addType(name, _.partial(fromJSONValueFunction, this));
      return this;
    },

    fromData(raw) {
      let data = {};
      _.each(this.prototype.fields(), function(Type, key) {
        if (raw[key] === undefined) return;
        let value = raw[key];
        if (value._type !== undefined) {
          // This is a sub-serializable
          data[key] = Space.resolvePath(value._type).fromData(raw[key]);
        } else if (_.isArray(value)) {
          // This is an array of values / sub-serializables
          data[key] = value.map(function(v) {
            if (v._type !== undefined) {
              return Space.resolvePath(v._type).fromData(v);
            } else {
              return v;
            }
          });
        } else {
          data[key] = value;
        }
      });
      return new this(data);
    }

  },

  // Mark this object as serializable
  isSerializable: true,

  /**
   * Recursivly turn this object and all it's sub-serializables into one
   * nested EJSON structure. Required by Meteor's EJSON package
   */
  toJSONValue() {
    let fields = this.fields();
    if (!fields || _.isEmpty(fields)) {
      // No special fields, simply parse instance to create deep copy
      return JSON.parse(JSON.stringify(this));
    } else {
      // Fields defined, parse them through EJSON to support nested types
      let serialized = {};
      for (let key in fields) {
        if (fields.hasOwnProperty(key) && this[key] !== undefined) {
          serialized[key] = EJSON.toJSONValue(this[key]);
        }
      }
      return serialized;
    }
  },

  toData() {
    let data = { _type: this.typeName() };
    _.each(this.fields(), (Type, key) => {
      if (this[key] === undefined) return;
      let value = this[key];
      if (value.isSerializable) {
        // This is another serializable
        data[key] = value.toData();
      } else if (_.isArray(value)) {
        // This is an array of sub values / Serializable
        data[key] = value.map(function(v) {
          return v.isSerializable ? v.toData() : v;
        });
      } else {
        data[key] = value;
      }
    });
    return data;
  }

};

// Todo: Refactor to mixin only! This is just there to support current systems
Space.Struct.extend(Space.messaging, 'Serializable', {
  mixin: [Space.messaging.SerializableMixin]
});
