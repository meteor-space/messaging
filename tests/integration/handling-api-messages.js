describe("handling api messages", function () {

  it("handles and re-hydrates commands", function () {
    var command = new MyCommand({
      targetId: '123',
      version: 1,
      timestamp: new Date(),
      value: new MyValue({ value: 'test' })
    });
    MyApp.test(MyApi).send(command).expect([command]);
  });

  it("handles normal method calls", function () {
    var id = '123';
    MyApp.test(MyApi).send('UncheckedMethod', id).expect([
      new AnotherCommand({ targetId: id })
    ]);
  });

});
