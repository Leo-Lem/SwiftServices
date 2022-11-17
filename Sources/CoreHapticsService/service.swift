
import CoreHaptics
import Errors
import HapticsService

open class CoreHapticsService: HapticsService {
  private let engine: CHHapticEngine

  public init() throws {
    engine = try CHHapticEngine()
  }

  public func play(_ pattern: Pattern) {
    printError {
      try engine.start()
      let player = try engine.makePlayer(with: try pattern.getCHPattern())
      try player.start(atTime: 0)
    }
  }
}
