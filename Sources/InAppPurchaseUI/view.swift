//	Created by Leopold Lemmermann on 07.10.22.

@_exported import InAppPurchaseService
import Previews
import LeosMisc
import SwiftUI

@available(iOS 16, macOS 13, *)
public extension PurchaseIdentifiable {
  func view<S: InAppPurchaseService>(service: S) -> some View where S.PurchaseID == Self {
    InAppPurchaseView(id: self, service: service)
  }
}

@available(iOS 16, macOS 13, *)
public struct InAppPurchaseView<S: InAppPurchaseService>: View {
  let purchase: Purchase<S.PurchaseID>
  let service: S

  public var body: some View {
    VStack {
      GroupBox {
        HStack {
          VStack {
            Text(purchase.name)
              .bold()
              .font(.largeTitle)
              .lineLimit(1)

            Text("FOR \(formattedPrice)", bundle: .module)
              .fontWeight(.medium)
              .font(.title)
          }
          .frame(maxWidth: .infinity)
        }
      }
      .padding()

      Text(purchase.desc)
        .font(.title2)
        .multilineTextAlignment(.center)
        .padding()

      Divider()

      InAppPurchaseButton(purchase, service: service, dismiss: dismiss.callAsFunction)
      .buttonStyle(.borderedProminent)
      .padding()
    }
    .aspectRatio(1 / 1, contentMode: .fit)
    .presentationDetents([.medium])
    #if os(iOS)
      .compactDismissButton()
    #endif
  }

  @Environment(\.dismiss) private var dismiss

  public init?(id: S.PurchaseID, service: S) {
    guard let purchase = service.getPurchase(with: id) else { return nil }
    
    self.purchase = purchase
    self.service = service
  }

  public init(purchase: Purchase<S.PurchaseID>, service: S) {
    self.purchase = purchase
    self.service = service
  }

  private var formattedPrice: String {
    purchase.price.formatted(.currency(code: Locale.current.currencyCode ?? "EUR"))
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  @available(iOS 16, macOS 13, *)
  struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
      InAppPurchaseView(id: .fullVersion, service: MockInAppPurchaseService<ExamplePurchaseID>())
        .previewInSheet()
    }
  }

  public enum ExamplePurchaseID: String, PurchaseIdentifiable {
    case fullVersion
  }
#endif
