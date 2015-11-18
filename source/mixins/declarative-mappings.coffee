Space.messaging.DeclarativeMappings = {

  dependencies: {
    underscore: 'underscore'
  }

  _setupDeclarativeMappings: (declarations, setup) ->
    mappings = {}
    declarations = this[declarations]()
    declarations.unshift mappings
    @underscore.extend.apply null, declarations
    @underscore.each mappings, setup

}
