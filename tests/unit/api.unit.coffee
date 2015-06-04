
describe 'Space.messaging - Api', ->

  handler = sinon.stub()
  methodName = 'Space.messaging.Api.__TestMethod__'

  class TestType extends Space.messaging.Serializable
    @type 'Space.messaging.Api.__TestType__'

  class MyApi extends Space.messaging.Api
    @method methodName, handler
    @method TestType, handler

  beforeEach ->
    @api = new MyApi()
    @api.onDependenciesReady()

  describe 'registering methods', ->

    it 'statically registers a meteor method', ->
      expect(Meteor.default_server.method_handlers[methodName]).to.exist

    it 'provides the correct arguments to the method handler', ->
      arg1 = {}
      arg2 = {}
      Meteor.call methodName, arg1, arg2
      expect(handler).to.have.been.calledWithMatch sinon.match.object, arg1, arg2

    it 'registers a method with the type name', ->
      expect(Meteor.default_server.method_handlers[TestType.toString()]).to.exist

    it 'checks the param for typed methods', ->
      param = new TestType()
      Meteor.call TestType, param
      expect(handler).to.have.been.calledWithMatch(
        sinon.match.object, sinon.match.instanceOf(TestType)
      )

    it 'throws exception if the check fails', ->
      expect(-> Meteor.call TestType, null).to.throw Error
