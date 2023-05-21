
import CoreHaptics
import Errors
import HapticsService

open class CoreHapticsService: HapticsService {
  private let engine: CHHapticEngine

  public init?() {
    guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return nil }
    do {
      engine = try CHHapticEngine()
    } catch {
      print("Couldn't create haptic engine: \(error.localizedDescription)")
      return nil
    }
  }

  public func play(_ pattern: Pattern) {
    printError {
      try engine.start()
      let player = try engine.makePlayer(with: try pattern.getCHPattern())
      try player.start(atTime: 0)
    }
  }
}
