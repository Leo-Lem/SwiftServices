# Association Service

An abstraction for working with key value storage (e.g., UserDefaults, NSUbiquitousKeyValueStore, Keychain).

## Features

- storing, loading and deleting item for key.
- storing codable items (with automatic encoding and decoding).
- getting all keys.
- clearing the storage.

## Implementations

### UserDefaultsService

An implementation for Foundation's UserDefaults.

### KeychainService

An implementation for storing data securely in Apple's Keychain. (abstracts away all the clunky Obj-C APIs)

_Note_: Only provides basic functionality for now (always uses the account field as key) -> not for complex use cases

### CloudDefaultsService

An extension of the UserDefaultsService adding automatic iCloud synchronization.
