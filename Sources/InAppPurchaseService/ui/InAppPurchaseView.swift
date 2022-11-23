//	Created by Leopold Lemmermann on 07.10.22.

import Concurrency
import LeosMisc
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

      if result == nil || result == .cancelled {
        Button(action: buy) {
          Label(
            "\(Text("PURCHASE_BUTTON \(formattedPrice)", bundle: .module))",
            systemImage: "cart"
          )
          .font(.title2)
          .padding(10)
          .frame(maxWidth: .infinity)

          if isPurchasing { ProgressView().padding(.horizontal) }
        }
        .buttonStyle(.borderedProminent)
        .padding(10)
      } else {
        GroupBox {
          Text(result == .success ? "THANK_YOU_MESSAGE" : "PENDING_MESSAGE", bundle: .module)
            .if(isPurchasing) { $0
              .overlay(content: ProgressView.init)
            }
        }
        .font(.title2)
        .padding(10)
        .multilineTextAlignment(.center)
      }
    }
    .alert(isPresented: Binding(optional: $error), error: error) {}
    .presentationDetents([.medium])
    .animation(.default, value: isPurchasing)
    .animation(.default, value: result)
  }

  @Environment(\.dismiss) var dismiss

  @State private var result: Purchase.Result?
  @State private var error: PurchaseError.Display?

  @State private var isPurchasing = false

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

  func buy() {
    Task(priority: .userInitiated) {
      do {
        isPurchasing = true

        self.result = try await (purchase.getPurchaseID() as ID?)
          .flatMap(service.purchase)

        isPurchasing = false

        if result != .cancelled {
          await sleep(for: .seconds(3))
          dismiss()
        }
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
