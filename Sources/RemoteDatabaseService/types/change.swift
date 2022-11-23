//	Created by Leopold Lemmermann on 09.11.22.

public enum RemoteDatabaseChange {
  case status(RemoteDatabaseStatus),
       published(any RemoteModelConvertible),
       unpublished(id: any CustomStringConvertible, type: any RemoteModelConvertible.Type),
       remote
}
