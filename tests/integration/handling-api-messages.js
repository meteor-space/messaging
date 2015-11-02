describe("handling api messages", function () {

  it("handles and re-hydrates commands", function () {
    var command = new TestApp.TestCommand({
      targetId: '123',
      version: 1,
      timestamp: new Date(),
      value: new TestApp.TestValue({ value: 'test' })
    });
    TestApp.test(TestApp.Api).send(command).expect([command]);
  });

  it("handles normal method calls", function () {
    var id = '123';
    TestApp.test(TestApp.Api)
    .send('UncheckedMethod', id)
    .expect([
      new TestApp.AnotherCommand({ targetId: id })
    ]);
  });

});
