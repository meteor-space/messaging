
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

    // Make this class EJSON serializable
    type(name) {
      this.prototype.typeName = this.toString = generateTypeNameMethod(name);
      this.classPath = name;
      EJSON.addType(name, _.partial(fromJSONValueFunction, this));
      Space.Struct.type(name, this);
      return this;
    },

    // Mark this class as serializable
    isSerializable: true
  },

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
  }
};

// Todo: Refactor to mixin only! This is just there to support current systems
Space.Struct.extend(Space.messaging, 'Serializable', {
  mixin: [Space.messaging.SerializableMixin]
});
