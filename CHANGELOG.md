Changelog
=========

### 0.5.0
Breaking Changes:
=================
- Removed the usage of futures for method apis

### 0.4.0
Breaking Changes:
=================
- Simplified the messaging api by keeping the event and command bus as simple
as possible and introducing a special `Space.messaging.Api` class that makes
working with async Meteor methods easier.
- Removes the options hash for `@handle` and `@on` methods of
`Space.messaging.Controller`. There are no options anymore because messages
can't cross the client/server boundary anmore. Use `Space.messaging.Api` for
that.
- The api for `Space.messaging.Controller` has changed a bit, use `@handle`
only for commands and `@on` for events.

Improvements:
=============
- Api is much simpler now
- You can send anything as command or event, it doesn't have to be a subclass

New Features:
=============
`Space.messaging.Api` was introduces which is a convenient abstraction layer
over Meteor methods to unify synchronouse and asynchronous method handling. It
sets up a future for each method call and hands it over to the method handler
together with the arguments and method context. This way you can work with
Promises and other async stuff without having to deal with setting up futures.
It also unifies the way you return stuff to the client, because you always
use the future for that.

### 0.3.5
Adds static `@method` function to `Space.messaging.Controller` that sets up
a Meteor method with a future to reduce boilerplate for async methods.

### 0.3.4
Adds `toPlainObject` method to `Space.messaging.Serializable` so that events
and commands can easily be casted to DTOs instead of class instances.

### 0.3.3
Allow (optionally) to provide source id of events as first parameter. This is
more convenient in scenarios where data is handed over from other places.

### 0.3.2
Adds short-hand API for handling controller messages

### 0.3.1
Improves error handling for `Space.messaging.Controller` when handling events
in the callback that is bound via `Meteor.bindEnvironment`. Now you can just
throw `Meteor.Error` instances and they are correctly routed back to the client.

### 0.3.0
Removes hooks for message handling because there is no real use case for it

### 0.2.1
Fixes bug with binding message handlers to Meteor environment and controller
instances.

### 0.2.0
Simplified serializable and event API and made it more flexible

### 0.1.0
Extracted messaging related code from space:cqrs into this package
