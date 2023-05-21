//	Created by Leopold Lemmermann on 17.11.22.

import CoreHaptics

extension CHHapticEvent {
  static let simple = CHHapticEvent(
    eventType: .hapticTransient,
    parameters: [.hapticSharpness, .hapticIntensity],
    relativeTime: 0
  )
  
  static let continuous = CHHapticEvent(
    eventType: .hapticContinuous,
    parameters: [.hapticSharpness, .hapticIntensity],
    relativeTime: 0.125,
    duration: 1
  )
}

extension CHHapticEventParameter {
  static let hapticSharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0),
             hapticIntensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)
}
