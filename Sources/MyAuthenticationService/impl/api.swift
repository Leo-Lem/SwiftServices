//	Created by Leopold Lemmermann on 21.11.22.

import Foundation

extension MyAuthenticationService {
  func callAPI<T: Encodable>(_ call: APICall, data: T) async throws -> (HTTPURLResponse?, Data) {
    do {
      var request = URLRequest(url: server.appendingPathComponent(call.rawValue))

      request.httpMethod = call.method
      request.setValue("application/json", forHTTPHeaderField: "Content-Type")
      request.httpBody = try JSONEncoder().encode(data)

      let (data, response) = try await URLSession.shared.data(for: request)
      return (response as? HTTPURLResponse, data)
    } catch { throw AuthenticationError.other(error) }
  }

  enum APICall: String {
    case exists,
         register,
         login,
         changePIN = "new-pin",
         deregister

    var method: String {
      switch self {
      case .exists: return "PUT"
      case .register: return "POST"
      case .login: return "PUT"
      case .changePIN: return "POST"
      case .deregister: return "DELETE"
      }
    }
  }
  
  #if DEBUG
  public func reset() async throws {
    var request = URLRequest(url: server)
    request.httpMethod = "DELETE"
    _ = try await URLSession.shared.data(for: request)
  }
  #endif
}
