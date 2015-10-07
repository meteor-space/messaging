
describe("Space.messaging.Controller - command handling", function () {

  beforeEach(function() {
    this.testCommand = new TestApp.TestCommand({
      targetId: '123',
      value: new TestApp.TestValue({ value: 'test' })
    });
    this.anotherCommand = new TestApp.AnotherCommand({ targetId: '123' });
  });

  describe("using event maps", function () {

    it("sets up context bound event handlers", function () {

      var commandHandlerSpy = sinon.spy();
      var anotherCommandHandler = sinon.spy();

      // Define a controller that uses the `events` API to declare handlers
      TestApp.TestController = Space.messaging.Controller.extend('TestController', {
        commands: function() {
          return [{
            'TestApp.TestCommand': commandHandlerSpy,
            'TestApp.AnotherCommand': anotherCommandHandler
          }];
        }
      });

      // Integrate the controller in our test app
      var ControllerTestApp = TestApp.extend('ControllerTestApp', {
        Singletons: ['TestApp.TestController']
      });

      // Startup app and send event through the bus
      var app = new ControllerTestApp();
      var controller = app.injector.get('TestApp.TestController');
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

  describe("using static api", function () {

    it("sets up context bound event handler", function () {

      var commandHandlerSpy = sinon.spy();

      // Define a controller that uses the `events` API to declare handlers
      TestApp.TestController = Space.messaging.Controller.extend('TestController')
      .handle(TestApp.TestCommand, commandHandlerSpy);

      // Integrate the controller in our test app
      var ControllerTestApp = TestApp.extend('ControllerTestApp', {
        Singletons: ['TestApp.TestController']
      });

      // Startup app and send event through the bus
      var app = new ControllerTestApp();
      var controller = app.injector.get('TestApp.TestController');
      app.start();
      app.commandBus.send(this.testCommand);

      // Expect that the controller routed the event correctly
      expect(commandHandlerSpy).to.have.been.calledWithExactly(this.testCommand);
      expect(commandHandlerSpy).to.have.been.calledOn(controller);

    });
  });
});
