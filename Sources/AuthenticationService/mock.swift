//	Created by Leopold Lemmermann on 21.10.22.

public extension AuthenticationService where Self == MockAuthenticationService {
  static var mock: MockAuthenticationService { MockAuthenticationService() }
}

open class MockAuthenticationService: AuthenticationService {
  public var eventPublisher = Publisher<AuthenticationStatus>()
  public var status: AuthenticationStatus = .notAuthenticated {
    didSet { eventPublisher.send(status) }
  }

  var store = Set<Credential>()
  
  public init() {}
  
  public func exists(_ id: Credential.ID) async throws -> Bool {
    print("Checking existence of \(id).")
    return store.contains { $0.id == id }
  }
  
  @discardableResult public func register(_ credential: Credential) async throws -> Credential.ID {
    guard !store.contains(where: { $0.id == credential.id }) else {
      throw AuthenticationError.registrationIDTaken(credential.id)
    }
    
    store.insert(credential)
    status = .authenticated(credential.id)
    print("Registered user with \(credential).")
    
    return credential.id
  }
  
  @discardableResult public func login(_ credential: Credential) async throws -> Credential.ID {
    guard let stored = store.first(where: { $0.id == credential.id }) else {
      throw AuthenticationError.authenticationUnknownID(credential.id)
    }
    
    guard stored.pin == credential.pin else {
      throw AuthenticationError.authenticationWrongPIN
    }
    
    status = .authenticated(credential.id)
    print("Logged user in with \(credential).")
    
    return credential.id
  }

  @discardableResult public func changePIN(_ newPIN: Credential.PIN) async throws -> Credential.ID {
    guard case let .authenticated(id) = status else { throw AuthenticationError.notAuthenticated }
    
    let credential = Credential(id: id, pin: newPIN)
    _ = store
      .firstIndex(where: { $0.id == id })
      .flatMap { store.remove(at: $0) }
    store.insert(credential)
    status = .authenticated(credential.id)
    print("Changed pin with \(id).")
    
    return credential.id
  }

  public func deregister() async throws {
    guard case let .authenticated(id) = status else { throw AuthenticationError.notAuthenticated }
    
    _ = store
      .firstIndex(where: { $0.id == id })
      .flatMap { store.remove(at: $0) }
    print("Deregistered user with \(id).")
    
    logout()
  }

  public func logout() {
    status = .notAuthenticated
    print("Logged user out.")
  }
}
