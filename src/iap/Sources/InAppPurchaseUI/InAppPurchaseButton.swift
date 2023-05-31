//	Created by Leopold Lemmermann on 02.12.22.

import Errors
import SwiftUI
import LeosMisc

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
struct InAppPurchaseButton<S: InAppPurchaseService>: View {
  let purchase: Purchase<S.PurchaseID>
  let service: S
  let dismiss: () -> Void

  var body: some View {
    AsyncButton(indicatorStyle: .edge(.trailing), taskPriority: .userInitiated) { await buy() } label: {
      HStack {
        Spacer()
        
        Label(
          finished ?
            String(localized: "PURCHASE_BUTTON_SUCCESS \(formattedPrice)", bundle: .module) :
            String(localized: "PURCHASE_BUTTON \(formattedPrice)", bundle: .module),
          systemImage: "cart"
        )
        .font(.title2)
        .padding()
        
        Spacer()
        
        if finished {
          Image(systemName: "checkmark.circle").imageScale(.large)
        }
      }
    }
    .disabled(finished)
    .alert(isPresented: Binding(item: $error), error: error) {}
    .alert(String(localized: "SUCCESS_TITLE", bundle: .module), isPresented: $isShowingSuccessAlert) {
      Button("OK") { dismiss() }
    } message: {
      Text("SUCCESS_MESSAGE", bundle: .module)
    }
    .alert(String(localized: "PENDING_TITLE", bundle: .module), isPresented: $isShowingPendingAlert) {
      Button("OK") { dismiss() }
    } message: {
      Text("PENDING_MESSAGE", bundle: .module)
    }
    .animation(.default, value: isPurchasing)
    .animation(.default, value: result)
  }
  
  @State private var isShowingSuccessAlert = false
  @State private var isShowingPendingAlert = false
  @State private var result: PurchaseResult?
  @State private var error: PurchaseError?
  @State private var isPurchasing = false

  init(_ purchase: Purchase<S.PurchaseID>, service: S, dismiss: @escaping () -> Void) {
    self.purchase = purchase
    self.service = service
    self.dismiss = dismiss
    
    if service.isPurchased(with: purchase.id) { result = .success }
  }
}

@available(iOS 16, macOS 13, tvOS 16, watchOS 9, *)
private extension InAppPurchaseButton {
  var finished: Bool { result == .success || result == .pending }
  
  var formattedPrice: String {
    purchase.price.formatted(.currency(code: Locale.current.currencyCode ?? "EUR"))
  }
  
  @MainActor func buy() async {
    await printError {
      do {
        result = try await service.purchase(with: purchase.id)
        
        if result == .success { isShowingSuccessAlert = true }
        if result == .pending { isShowingPendingAlert = true }
      } catch let error as PurchaseError where error.hasDescription { self.error = error }
    }
  }
}
