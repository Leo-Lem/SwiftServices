// Created by Leopold Lemmermann on 14.12.22.

import LeosMisc
import SwiftUI

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
struct SendButton: View {
  /// returns true when the action was successful
  let action: () async -> Bool

  var body: some View {
    AsyncButton(indicatorStyle: .replace, taskPriority: .userInitiated) { wasSuccessful = await action() } label: {
      if wasSuccessful {
        Image(systemName: "checkmark.circle")
      } else {
        Label(String(localized: "CONFIRM", bundle: .module), systemImage: "paperplane")
          .labelStyle(.iconOnly)
      }
    }
    .disabled(wasSuccessful)
  }

  @State private var wasSuccessful = false
  
  init(_ action: @escaping () async -> Bool) { self.action = action }
}

// MARK: - (PREVIEWS)

#if DEBUG
@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
struct SendButton_Previews: PreviewProvider {
  static var previews: some View {
    SendButton { true }
  }
}
#endif
