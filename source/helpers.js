Space.messaging.define = (BaseType, ...options) => {

  if (!BaseType.isSerializable) {
    throw new Error('BaseType must extend Space.messaging.Serializable');
  }

  let namespace = null;
  let definitions = null;
  let subTypes = {};

  switch (options.length) {
  case 0:
    throw new Error(`Space.messaging.define is missing options for defining sub typs of ${BaseType}.`);
  case 1:
    if (_.isObject(options[0])) {
      // VALID: Definitions but no namespace provided
      namespace = '';
      definitions = options[0];
    } else {
      throw new Error(`Space.messaging.define is missing definitions for ${BaseType}.`);
    }
    break;
  default:
    // VALID: Namespace and definitions provided
    namespace = options[0].toString();
    definitions = options[1];
    break;
  }

  _.each(definitions, (fields, className) => {
    let classPath = className;
    if (namespace !== '') classPath = `${namespace}.${className}`;
    let SubType = BaseType.extend(classPath);
    SubType.prototype.fields = () => _.extend(BaseType.prototype.fields(), fields);
    Space.resolvePath(namespace)[className] = SubType;
    subTypes[classPath] = SubType;
  });

  return subTypes;

};
