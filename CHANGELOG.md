Changelog
=========

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
