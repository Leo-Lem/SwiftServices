//	Created by Leopold Lemmermann on 17.11.22.

import CoreHaptics

extension CHHapticParameterCurve {
  static let parameterCurve = CHHapticParameterCurve(
    parameterID: .hapticIntensityControl,
    controlPoints: [.startPoint, .endPoint],
    relativeTime: 0
  )
}

extension CHHapticParameterCurve.ControlPoint {
  static let startPoint = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1),
             endPoint = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)
}

