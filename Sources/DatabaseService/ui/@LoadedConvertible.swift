// Created by Leopold Lemmermann on 14.12.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI

/// Loads the convertible using the database service from the environment.
@propertyWrapper public struct LoadedConvertible<T: Loadable, S: DatabaseService>: DynamicProperty {
  public let id: T.ID
  public var wrappedValue: T? { get { convertible } nonmutating set { convertible = newValue } }
  public var projectedValue: Binding<T?> { Binding { wrappedValue } set: { wrappedValue = $0 } }
  
  @State private var convertible: T?
  @EnvironmentObject private var service: S
  private let tasks = Tasks()
  
  public init(wrappedValue: T? = nil, with id: T.ID) {
    self.id = id
    _convertible = State(initialValue: wrappedValue)
  }
  
  public func update() {
    tasks["loadConvertible"] = Task(priority: .userInitiated) { await load(for: id) }
    tasks["updateConvertible"] = service.handleEventsTask(.userInitiated) { await update(on: $0) }
  }
  
  @MainActor private func load(for id: T.ID) async {
    await printError { convertible = try await service.fetch(with: id) }
  }
  
  @MainActor private func update(on event: DatabaseEvent) async {
    await printError {
      switch event {
      case let .inserted(type, newID) where type == T.self && newID as? T.ID == id:
        convertible ?= try await service.fetch(with: id)
      case let .deleted(type, newID) where type == T.self && newID as? T.ID == id:
        convertible = nil
      case .remote:
        await load(for: id)
      default:
        break
      }
    }
  }
}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
@propertyWrapper
public struct CachedConvertible<T: Loadable & Codable, S: DatabaseService>: DynamicProperty {
  public let id: T.ID
  public var wrappedValue: T? { get { convertible } nonmutating set { convertible = newValue } }
  public var projectedValue: Binding<T?> { Binding { wrappedValue } set: { wrappedValue = $0 } }
  
  @ObjectSceneStorage private var convertible: T?
  @EnvironmentObject private var service: S
  private let tasks = Tasks()
  
  public init(wrappedValue: T? = nil, with id: T.ID) {
    self.id = id
    _convertible = ObjectSceneStorage(wrappedValue: wrappedValue, id.description)
  }
  
  public func update() {
    tasks["loadConvertible"] = Task(priority: .userInitiated) { await load(for: id) }
    tasks["updateConvertible"] = service.handleEventsTask(.userInitiated) { await update(on: $0) }
  }
  
  @MainActor private func load(for id: T.ID) async {
    await printError { convertible = try await service.fetch(with: id) }
  }
  
  @MainActor private func update(on event: DatabaseEvent) async {
    await printError {
      switch event {
      case let .inserted(type, newID) where type == T.self && newID as? T.ID == id:
        convertible ?= try await service.fetch(with: id)
      case let .deleted(type, newID) where type == T.self && newID as? T.ID == id:
        convertible = nil
      case .remote:
        await load(for: id)
      default:
        break
      }
    }
  }
}
