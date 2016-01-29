
describe("Space.messaging.CommandHandling", function() {

  const CommandHandling = Space.messaging.CommandHandling;
  const MyClass = Space.Object.extend({ mixin: CommandHandling });

  it("does not provide empty default", function() {
    expect(MyClass.prototype.commandHandlers).not.to.exist;
  });

  it("does not throw error if no command handlers have been defined", function() {
    const createWithoutHandlers = function() {
      new MyClass({ underscore: _ }).onDependenciesReady();
    };
    expect(createWithoutHandlers).not.to.throw(Error);
  });

});
