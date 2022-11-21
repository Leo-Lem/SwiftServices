//	Created by Leopold Lemmermann on 20.11.22.

public struct Credential: Codable, Hashable {
  public var id: String,
             pin: String
  
  public init(id: String, pin: String) {
    self.id = id
    self.pin = pin
  }
}

public extension Credential {
  struct WithNewPIN: Codable, Hashable {
    public let credential: Credential,
               newPIN: String
  }
}

public extension Credential {
  func attachNewPIN(_ newPIN: String) -> Credential.WithNewPIN {
    Credential.WithNewPIN(credential: self, newPIN: newPIN)
  }
}
