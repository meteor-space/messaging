
describe("Event subscribing", function() {

  beforeEach(function() {
    this.myEvent = new MyEvent({
      value: new MyValue({ name: 'test' })
    });
    this.anotherEvent = new AnotherEvent({ });
  });

  it("subscribes to events", function() {

    let mySubscription = sinon.spy();
    let anotherSubscription = sinon.spy();

    // Define a controller that uses the `events` API to declare handlers
    MyController = Space.messaging.Controller.extend('MyController', {
      eventSubscriptions: function() {
        return [{
          'MyEvent': mySubscription,
          'AnotherEvent': anotherSubscription
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

    // Startup app and publish event through the bus
    let app = new ControllerTestApp();
    let myController = app.injector.get('MyController');
    app.start();
    app.eventBus.publish(this.myEvent);
    app.eventBus.publish(this.anotherEvent);

    // Expect that the controller subscribed to the events
    expect(mySubscription).to.have.been.calledWithExactly(this.myEvent).calledOn(myController);
    expect(anotherSubscription).to.have.been.calledWithExactly(this.anotherEvent).calledOn(myController);

  });
});
