// Created by Leopold Lemmermann on 14.12.22.

import SwiftUI

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
struct Header: View {
  let title: LocalizedStringKey
  let subtitle: LocalizedStringKey
  
  var body: some View {
    VStack {
      Text(title, bundle: .module)
        .bold()
        .font(.title)
        .frame(maxWidth: .infinity)
        .accessibilityAddTraits(.isHeader)

      Text(subtitle, bundle: .module)
        .font(.subheadline)
        .frame(maxWidth: .infinity)
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
struct Header_Previews: PreviewProvider {
  static var previews: some View {
    Header(title: "AUTHENTICATION_TITLE", subtitle: "AUTHENTICATION_SUBTITLE")
  }
}
#endif
