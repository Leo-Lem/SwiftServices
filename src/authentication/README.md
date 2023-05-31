# AuthenticationService

An abstraction of service providing authentication capabilities.

## Features

- Checking whether a User ID exists.
- Registering a new Credential (id and pin).
- Logging in with a Credential.
- Changing the pin for an ID.
- Deleting the Credential.
- Logging out.
- Quickly accessible authentication status.

## AuthenticationUI

A fully functional authentication page which hooks into an authentication service.

### Features

- Logging in and registering.
- Sign in with Apple.
- Localized interface.
- Automatically hooks into a provided authentication service for simple integration into whole app.
