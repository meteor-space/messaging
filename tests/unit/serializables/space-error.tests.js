describe("Space.messaging - Serializable Space.Error", function() {

  let MyCustomValue = Space.Struct.extend('MyCustomValue', {
    mixin: [Space.messaging.Ejsonable],
    statics: { fields: { value: String } }
  });

  let MyCustomError = Space.Error.extend('MyCustomError', {
    statics: { fields: { custom: MyCustomValue } }
  });

  it("makes Space.Error serializable", function() {
    let customValue = new MyCustomValue({ value: 'test' });
    let error = new MyCustomError({ custom: customValue });
    let copy = EJSON.parse(EJSON.stringify(error));
    expect(copy).to.be.instanceof(MyCustomError);
    expect(copy.custom).to.be.instanceof(MyCustomValue);
    expect(copy.custom.value).to.equal(customValue.value);
  });

});
