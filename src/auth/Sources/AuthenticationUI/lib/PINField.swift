// Created by Leopold Lemmermann on 14.12.22.

import SwiftUI

@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
struct PINField: View {
  @Binding var pin: Credential.PIN
  let prompt: String

  var body: some View {
    Group {
      if pinIsVisible {
        TextField(prompt, text: $pin)
          .focused($field, equals: .visible)
      } else {
        SecureField(prompt, text: $pin)
          .focused($field, equals: .hidden)
      }
    }
    .autocorrectionDisabled()
    .overlay(alignment: .trailing) {
      Button { pinIsVisible.toggle() } label: {
        pinIsVisible ?
          Label(String(localized: "HIDE_PIN", bundle: .module), systemImage: "eye.slash") :
          Label(String(localized: "SHOW_PIN", bundle: .module), systemImage: "eye")
      }
      .padding(.trailing, 10)
      .labelStyle(.iconOnly)
      .buttonStyle(.borderless)
    }
    .onChange(of: pinIsVisible) { field = $0 ? .visible : .hidden }
  }

  @State private var pinIsVisible = false
  @FocusState private var field: Field?

  enum Field { case hidden, visible }
}

// MARK: - (PREVIEWS)

#if DEBUG
@available(iOS 15, macOS 12, tvOS 15, watchOS 8, *)
struct PINField_Previews: PreviewProvider {
  static var previews: some View {
    PINField(pin: .constant(""), prompt: String(localized: "ENTER_PIN", bundle: .module))
      .padding()
  }
}
#endif
