//	Created by Leopold Lemmermann on 09.11.22.

public enum RemoteDatabaseChange {
  case status(RemoteDatabaseStatus),
       published(any RemoteModelConvertible),
       unpublished(any RemoteModelConvertible.Type),
       remote
}
