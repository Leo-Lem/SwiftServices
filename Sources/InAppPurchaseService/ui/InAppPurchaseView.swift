//	Created by Leopold Lemmermann on 07.10.22.

import Concurrency
import Previews
import SwiftUI

@available(iOS 16, macOS 13, *)
public extension Purchase {
  func view<ID: PurchaseIdentifiable>(id: ID.Type, service: InAppPurchaseService) -> some View {
    InAppPurchaseView(purchase: self, id: ID.self, service: service)
  }
}

@available(iOS 16, macOS 13, *)
public extension PurchaseIdentifiable {
  func view(service: InAppPurchaseService) -> some View {
    InAppPurchaseView(id: self, service: service)
  }
}

@available(iOS 16, macOS 13, *)
public struct InAppPurchaseView<ID: PurchaseIdentifiable>: View {
  let purchase: Purchase
  let service: InAppPurchaseService

  public var body: some View {
    VStack {
      GroupBox {
        Text(purchase.name)
          .bold()
          .font(.largeTitle)
        
        Text("FOR \(formattedPrice)", bundle: .module)
          .fontWeight(.medium)
          .font(.title)
      }
      
      Text(purchase.desc)
        .font(.title2)
        .multilineTextAlignment(.center)
        .padding()
      
      Divider()

      Button(action: executePurchase) {
        Label(
          "\(Text("PURCHASE_BUTTON \(formattedPrice)", bundle: .module))",
          systemImage: "cart"
        )
        .font(.title2)
        .padding(10)
        .frame(maxWidth: .infinity)
      }
      .buttonStyle(.borderedProminent)
      .padding()
    }
    .presentationDetents([.medium])
  }

  @State private var result: Purchase.Result?
  @State private var error: PurchaseError.Display?

  public init?(id: ID, service: InAppPurchaseService) {
    guard let purchase = service.getPurchase(id: id) else { return nil }
    self.purchase = purchase
    self.service = service
  }

  public init(purchase: Purchase, id: ID.Type, service: InAppPurchaseService) {
    self.purchase = purchase
    self.service = service
  }
}

@available(iOS 16, macOS 13, *)
private extension InAppPurchaseView {
  var formattedPrice: String {
    purchase.price
      .formatted(.currency(code: Locale.current.currencyCode ?? "EUR"))
  }

  func executePurchase() {
    Task(priority: .userInitiated) {
      do {
        self.result = try await (purchase.getPurchaseID() as ID?)
          .flatMap(service.purchase)
      } catch let error as PurchaseError {
        self.error = error.display
      }
    }
  }
}

// MARK: - (PREVIEWS)

#if DEBUG
  @available(iOS 16, macOS 13, *)
  struct ProductView_Previews: PreviewProvider {
    static var previews: some View {
      Purchase(
        id: "SomePurchase",
        name: "Unlock Full Version",
        desc: "With this you can unlock the full version of the app.",
        price: 2.99
      ).view(
        id: ExamplePurchaseID.self,
        service: MockInAppPurchaseService(ExamplePurchaseID.self)
      )
      .previewInSheet()
    }

    public enum ExamplePurchaseID: String, PurchaseIdentifiable {
      case fullVersion
    }
  }
#endif
