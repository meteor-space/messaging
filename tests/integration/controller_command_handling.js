
describe("Space.messaging.Controller - command handling", function () {

  beforeEach(function() {
    this.testCommand = new MyCommand({
      targetId: '123',
      value: new MyValue({ name: 'test' })
    });
    this.anotherCommand = new AnotherCommand({ targetId: '123' });
  });

  it("sets up context bound command handlers", function () {

    var commandHandlerSpy = sinon.spy();
    var anotherCommandHandler = sinon.spy();

    // Define a controller that uses the `events` API to declare handlers
    MyController = Space.messaging.Controller.extend('MyController', {
      commandHandlers: function() {
        return [{
          'MyCommand': commandHandlerSpy,
          'AnotherCommand': anotherCommandHandler
        }];
      }
    });

    // Integrate the controller in our test app
    var ControllerTestApp = Space.Application.define('ControllerTestApp', {
      afterInitialize: function() {
        this.injector.map('MyController').toSingleton(MyController);
      }
    });

    // Startup app and send event through the bus
    var app = new ControllerTestApp();
    var controller = app.injector.get('MyController');
    app.start();
    app.commandBus.send(this.testCommand);
    app.commandBus.send(this.anotherCommand);

    // Expect that the controller routed the events correctly
    expect(commandHandlerSpy).to.have.been.calledWithExactly(this.testCommand);
    expect(commandHandlerSpy).to.have.been.calledOn(controller);
    expect(anotherCommandHandler).to.have.been.calledWithExactly(this.anotherCommand);
    expect(anotherCommandHandler).to.have.been.calledOn(controller);

  });
});
