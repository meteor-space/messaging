
Serializable = Space.messaging.Serializable

describe "Space.messaging.Serializable", ->

  describe 'construction', ->

    it 'cannot be instantiated directly', ->
      expect(-> new Serializable).to.throw Error

    it 'throws an error if type is not set on sub classes', ->
      class TestClass extends Space.messaging.Serializable
      expect(-> new TestClass).to.throw Error

    describe 'setting the type', ->

      BasicTestType = Space.messaging.Serializable.extend ->
        @type 'Space.messaging.BasicTestType'

      it 'allows the class to be instantiated', ->
        expect(-> new BasicTestType).not.to.throw Error

      it 'makes the class EJSON serializable', ->
        instance = new BasicTestType()
        copy = EJSON.parse EJSON.stringify(instance)
        expect(instance).not.to.equal copy
        expect(copy).to.be.instanceof BasicTestType

    describe 'defining fields', ->

      class TestTypeWithFields extends Space.messaging.Serializable
        @type 'Space.messaging.TestTypeWithFields', ->
          name: String
          age: Match.Integer

      class TestTypeWithNestedTypes extends Space.messaging.Serializable
        @type 'Space.messaging.TestTypeWithNestedTypes', ->
          sub: TestTypeWithFields

      it 'creates the instance and copies the fields over', ->
        instance = new TestTypeWithFields name: 'Dominik', age: 26
        copy = EJSON.parse EJSON.stringify(instance)

        expect(instance.name).to.equal 'Dominik'
        expect(instance.age).to.equal 26
        expect(instance).to.deep.equal copy

      it 'handles sub types correctly', ->
        subType = new TestTypeWithFields name: 'Dominik', age: 26
        instance = new TestTypeWithNestedTypes sub: subType
        copy = EJSON.parse EJSON.stringify(instance)

        expect(instance.sub).to.equal subType
        expect(instance).to.deep.equal copy
