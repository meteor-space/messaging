
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

        expect(instance.name).to.equal 'Dominik'
        expect(instance.age).to.equal 26
        expect(instance).to.deep.equal copy

      it 'handles sub types correctly', ->
        subType = new TestTypeWithFields name: 'Dominik', age: 26
        instance = new TestTypeWithNestedTypes sub: subType
        copy = EJSON.parse EJSON.stringify(instance)

        expect(instance.sub).to.equal subType
        expect(instance).to.deep.equal copy
