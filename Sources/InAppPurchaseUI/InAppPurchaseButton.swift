//	Created by Leopold Lemmermann on 02.12.22.

import AVKit
import Errors
import SwiftUI

@available(iOS 15, macOS 12, *)
struct InAppPurchaseButton<S: InAppPurchaseService>: View {
  let purchase: Purchase<S.PurchaseID>
  let service: S
  let dismiss: () -> Void

  var body: some View {
    Button { buy() } label: {
      Spacer()
      Label(
        finished ?
          String(localized: "PURCHASE_BUTTON_SUCCESS \(formattedPrice)", bundle: .module) :
          String(localized: "PURCHASE_BUTTON \(formattedPrice)", bundle: .module),
        systemImage: "cart"
      )
      .font(.title2)
      .padding(10)
      Spacer()

      if isPurchasing || finished {
        Image(systemName: "checkmark.circle").imageScale(.large)
          .if(isPurchasing) { $0
            .hidden()
            .overlay(content: ProgressView.init)
          }
      }
    }
    .disabled(finished)
    .alert(isPresented: Binding(optional: $error), error: error) {}
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

@available(iOS 15, macOS 12, *)
private extension InAppPurchaseButton {
  private var finished: Bool { result == .success || result == .pending }
  
  private var formattedPrice: String {
    purchase.price.formatted(.currency(code: Locale.current.currencyCode ?? "EUR"))
  }

  @MainActor private func buy() {
    Task(priority: .userInitiated) {
      do {
        isPurchasing = true
        self.result = try await service.purchase(with: purchase.id)
        isPurchasing = false
        
        if result == .success { isShowingSuccessAlert = true }
        if result == .pending { isShowingPendingAlert = true }
      } catch let error as PurchaseError where error.hasDescription { self.error = error }
    }
  }
}
