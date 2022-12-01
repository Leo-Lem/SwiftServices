#if os(macOS)
import BaseTests
@testable import MyAuthenticationService

class MyAuthenticationServiceTests: BaseTests<MyAuthenticationService> {
  override func setUp() async throws {
    service = await .init(
      server: URL(string: "http://127.0.0.1:8080")!,
      keyValueStorageService: .mock
    )

    try await service.reset()
  }
}

// setting up the development server
extension MyAuthenticationServiceTests {
  override static func setUp() { startDevServer() }
  override static func tearDown() { devServer.terminate() }

  private static let devServer: Process = {
    let process = Process()
    process.executableURL = Bundle.module.url(forResource: "devServer", withExtension: "")!
    return process
  }()

  private static func startDevServer() {
    let s = DispatchSemaphore(value: 0)
    Task {
      try devServer.run()
      try await Task.sleep(nanoseconds: 1_000_000_000) // give server some time start
      s.signal()
    }
    s.wait()
  }
}
#endif
