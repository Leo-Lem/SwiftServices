//	Created by Leopold Lemmermann on 21.11.22.

extension AuthenticationStatus: Equatable {
  public static func == (lhs: AuthenticationStatus, rhs: AuthenticationStatus) -> Bool {
    switch (lhs, rhs) {
    case (.notAuthenticated, .notAuthenticated):
      return true
    case let (.authenticated(id1), .authenticated(id2)):
      return id1 == id2
    default:
      return false
    }
  }
}
