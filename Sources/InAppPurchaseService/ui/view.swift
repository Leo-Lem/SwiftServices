//	Created by Leopold Lemmermann on 07.10.22.

import Concurrency
import LeosMisc
import Previews
import SwiftUI

@available(iOS 16, macOS 13, *)
public extension Purchase {
  func view<S: InAppPurchaseService>(service: S) -> some View where S.PurchaseID == ID {
    InAppPurchaseView(purchase: self, service: service)
  }
}

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

  @State private var result: Purchase<S.PurchaseID>.Result?
  @State private var error: PurchaseError.Display?

  @State private var isPurchasing = false

  public init?(id: S.PurchaseID, service: S) {
    guard let purchase = service.getPurchase(with: id) else { return nil }
    self.purchase = purchase
    self.service = service
  }

  public init(purchase: Purchase<S.PurchaseID>, service: S) {
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

        self.result = try await service.purchase(with: purchase.id)

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
        id: ExamplePurchaseID.fullVersion,
        name: "Unlock Full Version",
        desc: "With this you can unlock the full version of the app.",
        price: 2.99
      ).view(
        service: MockInAppPurchaseService<ExamplePurchaseID>()
      )
      .previewInSheet()
    }

    public enum ExamplePurchaseID: String, PurchaseIdentifiable {
      case fullVersion
    }
  }
#endif
