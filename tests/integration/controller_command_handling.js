
describe("Handling commands", function() {

  beforeEach(function() {
    this.myCommand = new MyCommand({
      value: new MyValue({name: 'test'})
    });
    this.anotherCommand = new AnotherCommand({
      myCustomTarget: '123'
    });
  });

  it("handles commands", function() {
    let myHandler = sinon.spy();
    let anotherHandler = sinon.spy();

    // Define a controller, declare handlers
    MyController = Space.messaging.Controller.extend('MyController', {
      commandHandlers: function() {
        return [{
          'MyCommand': myHandler,
          'AnotherCommand': anotherHandler
        }];
      }
    });

    // Integrate the controller in our test app
    let ControllerTestApp = Space.Application.define('ControllerTestApp', {
      requiredModules: ['Space.messaging'],
      afterInitialize: function() {
        this.injector.map('MyController').toSingleton(MyController);
      }
    });

    // Startup app and send the commands through the bus
    let app = new ControllerTestApp();
    let myController = app.injector.get('MyController');
    app.start();
    app.commandBus.send(this.myCommand);
    app.commandBus.send(this.anotherCommand);

    // Expect that the controller handled the commands
    expect(myHandler).to.have.been.calledWithExactly(this.myCommand).calledOn(myController);
    expect(anotherHandler).to.have.been.calledWithExactly(this.anotherCommand).calledOn(myController);

  });
});
