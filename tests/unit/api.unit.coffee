
describe 'Space.messaging - Api', ->

  describe 'registering methods', ->

    handler = sinon.stub()
    methodName = 'Space.messaging.ApiTestMethod'
    class MyApi extends Space.messaging.Api
      @method methodName, handler

    beforeEach ->
      @futureWait = { test: 'test' }
      @future = wait: sinon.stub()
      @future.wait.returns @futureWait
      @Future = sinon.stub()
      @Future.returns @future

      @api = new MyApi Future: @Future
      @api.onDependenciesReady()

    it 'statically registers a meteor method', ->
      expect(Meteor.default_server.method_handlers[methodName]).to.exist

    it 'creates a future for each method request', ->
      returnValue = Meteor.call methodName
      expect(@Future).to.have.been.calledWithNew
      expect(returnValue).to.eql @futureWait

    it 'provides the correct arguments to the method handler', ->
      arg1 = {}
      arg2 = {}
      Meteor.call methodName, arg1, arg2
      expect(handler).to.have.been.calledWithMatch(
        sinon.match.object, arg1, arg2, @future
      )
