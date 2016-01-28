Space.messaging.DeclarativeMappings = {

  dependencies: {
    underscore: 'underscore'
  },

  _setupDeclarativeMappings(map, setup) {
    let mappings = {};
    let declarations = this[map]();
    if (!this.underscore.isArray(declarations)) {
      declarations = [declarations];
    }
    declarations.unshift(mappings);
    this.underscore.extend.apply(null, declarations);
    this.underscore.each(mappings, setup);
  }

};
