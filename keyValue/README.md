# Key-Value Storage Service

An abstraction for workign with key value storage (e.g., UserDefaults, NSUbiquitousKeyValueStore).

## Features

- storing, loading and deleting item for key.
- storing items securely (e.g., in Keychain).
- getting all keys.
- storing codable items (with automatic encoding and decoding).

## How to use

Subclass UserDefaultsService and add your own functionality, or use it as is.
