//	Created by Leopold Lemmermann on 20.11.22.

public enum AuthenticationError: Error {
  case noConnection,
       notAuthenticated,
       registrationIDTaken,
       registrationInvalidID,
       modificationInvalidNewPIN,
       authenticationUnknownID,
       authenticationWrongPIN,
       unexpected(status: Int),
       other(Error?)
}
