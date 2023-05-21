//	Created by Leopold Lemmermann on 17.11.22.

import CoreHaptics
import HapticsService

extension Pattern {
  func getCHPattern() throws -> CHHapticPattern {
    switch self {
    case .taDa:
      return try CHHapticPattern(
        events: [.simple, .continuous],
        parameterCurves: [.parameterCurve])
    }
  }
}
