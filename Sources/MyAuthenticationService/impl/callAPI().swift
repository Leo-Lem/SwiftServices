//	Created by Leopold Lemmermann on 21.11.22.

import Foundation
import AuthenticationService

extension MyAuthenticationService {
  func callAPI<T: Encodable>(
    _ route: Route,
    method: HTTPMethod,
    data: T
  ) async throws -> (Data, HTTPURLResponse?) {
    var request = URLRequest(url: url.appendingPathComponent(route.rawValue))
    
    request.httpMethod = method.rawValue
    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
    request.httpBody = try JSONEncoder().encode(data)

    let (data, response) = try await URLSession.shared.data(for: request)
    return (data, response as? HTTPURLResponse)
  }
}
