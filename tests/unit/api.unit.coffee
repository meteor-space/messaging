
describe 'Space.messaging - Api', ->

  describe 'registering methods', ->

    handler = sinon.stub()
    methodName = 'Space.messaging.ApiTestMethod'
    class MyApi extends Space.messaging.Api
      @method methodName, handler

    beforeEach ->
      @api = new MyApi()
      @api.onDependenciesReady()

    it 'statically registers a meteor method', ->
      expect(Meteor.default_server.method_handlers[methodName]).to.exist

    it 'provides the correct arguments to the method handler', ->
      arg1 = {}
      arg2 = {}
      Meteor.call methodName, arg1, arg2
      expect(handler).to.have.been.calledWithMatch sinon.match.object, arg1, arg2
