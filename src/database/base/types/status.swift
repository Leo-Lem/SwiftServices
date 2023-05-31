//	Created by Leopold Lemmermann on 27.10.22.

/// The ``DatabaseService``'s current status.
public enum DatabaseStatus: Equatable {
  /// Read and write operation are possible.
  case available

  /// Only read operations are possible.
  case readOnly
  
  /// The database is unavailable.
  case unavailable
}
