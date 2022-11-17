# Remote Database Service

An abstraction for accessing a remote database (e.g., CloudKit).

## Features

- publishing convertibles.
- unpublishing convertibles.
- fetching convertibles using a custom Query type (see [Queries](https://github.com/Leo-Lem/Queries) package).

## How to use

1. Create remote database model (e.g., CloudKit records), mirroring your own model.
2. Conform your Swift Model types to RemoteDatabaseConvertible.
3. Implement your Public Database Service, or use one available (only CloudKit right now).

### Conforming to RemoteDatabaseConvertible

1. Specify your remote database model type (e.g., CKRecord).
2. Specify a String identifier for the remote database type (e.g., a recordType).
3. Mapping to the remote database model: A method mapProperties, taking an instance of the remote database model and returning said instance after modification.
4. Mapping from the remote database model: An initializer taking an instance of the remote database model.
