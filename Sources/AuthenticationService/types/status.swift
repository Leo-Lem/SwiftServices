//	Created by Leopold Lemmermann on 21.10.22.

import class Combine.PassthroughSubject
public typealias StatusChangePublisher = PassthroughSubject<AuthenticationStatus, Never>

public enum AuthenticationStatus {
  case notAuthenticated,
       authenticated(_ id: Credential.ID)
}
