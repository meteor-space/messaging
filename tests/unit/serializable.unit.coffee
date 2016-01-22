
Serializable = Space.messaging.Serializable
test = Space.namespace 'Space.messaging.__test__'

class test.MySerializable extends Serializable
  @type 'Space.messaging.__test__.MySerializable'
  fields: -> name: String, age: Match.Integer

class test.MyNestedSerializable extends Serializable
  @type 'Space.messaging.__test__.MyNestedSerializable'
  fields: -> {
    single: test.MySerializable
    multiple: [test.MySerializable]
  }

describe "Serializable", ->

  it 'is a test', ->
    expect(Serializable).to.extend Space.Struct

  describe 'construction', ->

    describe 'setting the type', ->

      class BasicTestType extends Serializable
        @type 'Space.messaging.BasicTestType'

      it 'makes the class EJSON serializable', ->
        instance = new BasicTestType()
        copy = EJSON.parse EJSON.stringify(instance)
        expect(instance).not.to.equal copy
        expect(copy).to.be.instanceof BasicTestType

    describe 'defining fields', ->

      class TestTypeWithFields extends Serializable
        @type 'Space.messaging.TestTypeWithFields'
        @fields: name: String, age: Match.Integer

      class TestTypeWithNestedTypes extends Serializable
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

      Space.messaging.define Serializable, 'Space.messaging.__test__',
        SubType: type: String

      Space.messaging.define Serializable, 'Space.messaging.__test__',
        SuperType:
          sub: test.SubType

      it 'sets up serializables correctly', ->

        subType = new test.SubType type: 'test'
        instance = new test.SuperType sub: subType
        copy = EJSON.parse EJSON.stringify(instance)

        expect(instance.sub).to.be.instanceof test.SubType
        expect(instance.sub).to.equal subType
        expect(instance).to.be.instanceof test.SuperType
        expect(instance).to.deep.equal copy

  describe "serializing to and from plain object hierarchies", ->

    exampleNestedData = {
      _type: 'Space.messaging.__test__.MyNestedSerializable'
      single: { _type: 'Space.messaging.__test__.MySerializable', name: 'Test', age: 10 }
      multiple: [
        { _type: 'Space.messaging.__test__.MySerializable', name: 'Bla', age: 2 }
        { _type: 'Space.messaging.__test__.MySerializable', name: 'Blub', age: 5 }
      ]
    }

    describe "::toData", ->

      it "returns a hierarchy of plain data objects", ->
        mySerializable = new test.MyNestedSerializable {
          single: new test.MySerializable(name: 'Test', age: 10)
          multiple: [
            new test.MySerializable(name: 'Bla', age: 2)
            new test.MySerializable(name: 'Blub', age: 5)
          ]
        }
        expect(mySerializable.toData()).to.deep.equal exampleNestedData

    describe ".fromData", ->

      it "constructs the struct hierarchy from plain data object hierarchy", ->

        mySerializable = test.MyNestedSerializable.fromData exampleNestedData
        expect(mySerializable).to.be.instanceOf(test.MyNestedSerializable)
        expect(mySerializable.single).to.be.instanceOf(test.MySerializable)
        expect(mySerializable.multiple[0].toData()).to.deep.equal exampleNestedData.multiple[0]
        expect(mySerializable.multiple[1].toData()).to.deep.equal exampleNestedData.multiple[1]
