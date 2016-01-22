describe("handling api messages", function() {

  beforeEach(function() {
    this.command = new MyCommand({
      value: new MyValue({ name: 'good-value' })
    });
  });

  it("sends a handled command on the server-side command bus if passes validation", function() {
    MyApp.test(MyApi).send(this.command).expect([this.command]);
  });

  it("does not send a handled command on the server-side command bus if fails validation", function() {
    this.command.value = new MyValue({ name: 'bad-value' });
    MyApp.test(MyApi).send(this.command).expect([]);
  });

  it("receives any values that are compatible with meteor methods", function() {
    let id = '123';
    MyApp.test(MyApi).call('UncheckedMethod', id).expect([
      new AnotherCommand({ myCustomTarget: id })
    ]);
  });

});
