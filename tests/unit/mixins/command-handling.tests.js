
describe("Space.messaging.CommandHandling", function() {

  const MyClass = Space.Object.extend({
    mixin: Space.messaging.CommandHandling
  });
  const MyCommand = Space.messaging.Command.extend(
    'Space.messaging.CommandHandling.__Test__.MyCommand',
    {}
  );

  it("does not provide empty default", function() {
    expect(MyClass.prototype.commandHandlers).not.to.exist;
  });

  it("does not throw error if no command handlers have been defined", function() {
    const createWithoutHandlers = function() {
      new MyClass({ underscore: _ }).onDependenciesReady();
    };
    expect(createWithoutHandlers).not.to.throw(Error);
  });

  describe("public methods", function() {

    beforeEach(function () {
      this.myClassInstance = new MyClass({
        meteor: Meteor,
        commandBus: new Space.messaging.CommandBus,
        underscore: _
      });
      this.myCommandInstance = new MyCommand();
    });

    describe("canHandleCommand", function () {

      it("returns true if object has a registered handler function", function () {
        const handler = sinon.spy();
        this.myClassInstance.register(MyCommand, handler);
        expect(this.myClassInstance.canHandleCommand(this.myCommandInstance)).to.be.true;
      });

      it("returns false if object has no registered handler functions", function () {
        const handler = sinon.spy();
        expect(this.myClassInstance.canHandleCommand(this.myCommandInstance)).to.be.false;
      });

    });

    describe("register", function () {

      it("registers the provided function to handle the specified command sent through the command bus", function () {
        const handler = sinon.spy();
        this.myClassInstance.register(MyCommand, handler);
        expect(this.myClassInstance.commandBus.hasHandlerFor(this.myCommandInstance)).to.be.true;
      });

    });

    describe("handle", function () {

      it("calls the handler when passed a command it can handle", function () {
        const handler = sinon.spy();
        this.myClassInstance.register(MyCommand, handler);
        this.myClassInstance.handle(this.myCommandInstance);
        expect(handler).to.have.been.called;
      });

      it("throws an error if the command cannot be handled", function () {
        const createWithoutHandlers = function () {
          this.myClassInstance.handle(this.myCommandInstance);
        };
        expect(createWithoutHandlers).to.throw.error;
      });

    });

  });

});
