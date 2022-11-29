//	Created by Leopold Lemmermann on 09.11.22.

import class Combine.PassthroughSubject

public typealias DidChangePublisher = PassthroughSubject<RemoteDatabaseChange, Never>

public enum RemoteDatabaseChange {
  case status(RemoteDatabaseStatus),
       published(any RemoteModelConvertible),
       unpublished(id: any CustomStringConvertible, type: any RemoteModelConvertible.Type),
       remote
}
