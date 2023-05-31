# Database Service

A Swift service abstracting database access (like CoreData or CloudKit).

## Features

- Linking your Swift native data models with their database representation via the DatabaseObjectConvertible protocol.
- Inserting, modifying and deleting objects from the database (using only convertibles, no database object types).
- Fetching convertibles using their id or just checking for their existence.
- Querying the database using a custom Query type (see Queries in the [LeosSwift](https://github.com/Leo-Lem/LeosSwift) package).
- Where possible, everything is executed asynchronously, as to not block up the main thread.

## Getting Started

1. Create database model (e.g., NSManagedObjectModel, CloudKit records), mirroring your Swift model.
2. Conform your Swift model types to DatabaseObjectConvertible
  - Specify your database object type (e.g., CKRecord, some NSManagedObject).
  - Specify a String identifier for the database object type (e.g., a recordType, an entity name).
  - Mapping to the database object (`mapProperties(onto databaseObject:)`).
  - Mapping from the database object(`init(from databaseObject:)`).
3. Use an available service (CloudKit, CoreData) or create your own and provide the necessary prerequesites
  - **CloudKit**: Provide your `CKContainer` and specify the scope.
  - **CoreData**: Provide your `NSPersistentContainer`.
