
Serializable = Space.messaging.Serializable

describe "Space.messaging.Serializable", ->

  it 'is a struct', ->
    expect(Space.messaging.Serializable).to.extend Space.Struct

  describe 'construction', ->

    describe 'setting the type', ->

      class BasicTestType extends Space.messaging.Serializable
        @type 'Space.messaging.BasicTestType'

      it 'makes the class EJSON serializable', ->
        instance = new BasicTestType()
        copy = EJSON.parse EJSON.stringify(instance)
        expect(instance).not.to.equal copy
        expect(copy).to.be.instanceof BasicTestType

    describe 'defining fields', ->

      class TestTypeWithFields extends Space.messaging.Serializable
        @type 'Space.messaging.TestTypeWithFields'
        @fields: name: String, age: Match.Integer

      class TestTypeWithNestedTypes extends Space.messaging.Serializable
        @type 'Space.messaging.TestTypeWithNestedTypes'
        @fields: sub: TestTypeWithFields

      it 'creates the instance and copies the fields over', ->
        instance = new TestTypeWithFields name: 'Dominik', age: 26
        copy = EJSON.parse EJSON.stringify(instance)

        expect(copy).to.instanceof TestTypeWithFields
        expect(instance.name).to.equal 'Dominik'
        expect(instance.age).to.equal 26
        expect(instance).to.deep.equal copy

      it 'handles sub types correctly', ->
        subType = new TestTypeWithFields name: 'Dominik', age: 26
        instance = new TestTypeWithNestedTypes sub: subType
        copy = EJSON.parse EJSON.stringify(instance)

        expect(instance.sub).to.equal subType
        expect(instance).to.deep.equal copy

    describe 'define serializables helper', ->
      Space.messaging.__test__ = {}
      namespace = Space.messaging.__test__

      Space.messaging.define Serializable, namespace, 'Space.messaging.__test__',
        SubType: type: String

      Space.messaging.define Serializable, namespace, 'Space.messaging.__test__',
        SuperType:
          sub: Space.messaging.__test__.SubType

      it 'sets up serializables correctly', ->

        subType = new Space.messaging.__test__.SubType type: 'test'
        instance = new Space.messaging.__test__.SuperType sub: subType
        copy = EJSON.parse EJSON.stringify(instance)

        expect(instance.sub).to.be.instanceof Space.messaging.__test__.SubType
        expect(instance.sub).to.equal subType
        expect(instance).to.be.instanceof Space.messaging.__test__.SuperType
        expect(instance).to.deep.equal copy
