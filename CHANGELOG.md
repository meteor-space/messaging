Changelog
=========

## 1.7.0
Adds versioning support for `Space.messaging.Event`. This makes it possible
to have multiple versions of saved event data and dynamically migrate older
versions to the latest required structure. Take a look at the unit tests to
get a feeling how this works ;-)

## 1.6.1
Updated location of Github repository to https://github.com/meteor-space/messaging

## 1.6.0
- Improves API of `Space.messaging.define` for use in Javascript.
- Let static methods like `Controller::handle` and `on` always return the class
instance so that it can be chained (again more beautiful in Javascript).

## 1.5.2
- Improves the way `Space.messaging.Serializable` objects are serialized from and
to EJSON values. It uses `toJSONValue` and `fromJSONValue` instead of `stringify`
and `parse` to tranform the fields now.

## 1.5.1
- EJSON stringify and parse distributed events to avoid the weird transformations done by Meteor mongo driver. This makes integration
with standard EJSON much easier, e.g when using the ejson npm package.

## 1.5.0
- Adds first draft of a basic API for distributed events via a shared mongo
collection that can be used to integrate separate apps.

## 1.4.2
- Provide publish context as first argument like for api methods.

## 1.4.1
- Adds the sugar methods `publish` and `send` to `Space.messaging.Controller`
which forward the respective messages to the event and command busses.

## 1.4.0
- Map `Space.messaging.Api` as static value
- Allow to pass a callback for `Space.messaging.Api#send` as last param

## 1.3.2
Adds `Space.messaging.Api.send` method which is a simple sugar wrapper around
`Meteor.call` to send events and commands to the server.

## 1.3.1
Moves `Space.messaging.Api` into shared environment so that you can also
setup a method simulations like normal in Meteor. To check if it is a simulation
just use the first context param where `isSimulation` should be defined.

## 1.3.0

- Adds a very simple wrapper around `Tracker.autorung` called `Space.messaging.Tracker`
which can be used in scenarios where you want to run code reactively in response
to property changes.
- Another sweet sugar around `Meteor.publish` called `Space.messaging.Publication`
which allows to define `@publish 'my-name', (param1, param2, …) ->` publications
which are run in the context of the class instance.

## 1.2.2

- Improves error handling while defining event and command handlers in
`Space.messaging.Controller`
- Fixes problem with defining serializables
- Allow null values to be serialized

## 1.2.1
Introduces convenient API `Space.messaging.defineSerializables` which can be
used to define any number of serializables at once without the boilerplate of
class definitions.

## 1.1.0
- Introduces (optional) typed methods for `Space.messaging.Api`. This makes it
possible that the message type is automatically checked for you like this:

```coffeescript
order = new BeerOrder {
  brand: 'Budweiser'
  quantity: 20
  address: new Address( … )
}

Meteor.call BeerOrder, order

class BeerOrderApi extends Space.messaging.Api
  @method BeerOrder, (order) -> # No need to check!
```

## 1.0.0
#### Breaking Changes:
- Upgrades to `space:base@2.0.0` which had some (minor) breaking changes to the modules and application API.

## 0.5.0
#### Breaking Changes:
- Removed the usage of futures for method apis

## 0.4.0
### Breaking Changes:
- Simplified the messaging api by keeping the event and command bus as simple
as possible and introducing a special `Space.messaging.Api` class that makes
working with async Meteor methods easier.
- Removes the options hash for `@handle` and `@on` methods of
`Space.messaging.Controller`. There are no options anymore because messages
can't cross the client/server boundary anmore. Use `Space.messaging.Api` for
that.
- The api for `Space.messaging.Controller` has changed a bit, use `@handle`
only for commands and `@on` for events.

### Improvements:
- Api is much simpler now
- You can send anything as command or event, it doesn't have to be a subclass

### New Features:
`Space.messaging.Api` was introduces which is a convenient abstraction layer
over Meteor methods to unify synchronouse and asynchronous method handling. It
sets up a future for each method call and hands it over to the method handler
together with the arguments and method context. This way you can work with
Promises and other async stuff without having to deal with setting up futures.
It also unifies the way you return stuff to the client, because you always
use the future for that.

## 0.3.5
Adds static `@method` function to `Space.messaging.Controller` that sets up
a Meteor method with a future to reduce boilerplate for async methods.

## 0.3.4
Adds `toPlainObject` method to `Space.messaging.Serializable` so that events
and commands can easily be casted to DTOs instead of class instances.

## 0.3.3
Allow (optionally) to provide source id of events as first parameter. This is
more convenient in scenarios where data is handed over from other places.

## 0.3.2
Adds short-hand API for handling controller messages

## 0.3.1
Improves error handling for `Space.messaging.Controller` when handling events
in the callback that is bound via `Meteor.bindEnvironment`. Now you can just
throw `Meteor.Error` instances and they are correctly routed back to the client.

## 0.3.0
Removes hooks for message handling because there is no real use case for it

## 0.2.1
Fixes bug with binding message handlers to Meteor environment and controller
instances.

## 0.2.0
Simplified serializable and event API and made it more flexible

## 0.1.0
Extracted messaging related code from space:cqrs into this package
