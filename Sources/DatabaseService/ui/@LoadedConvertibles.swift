//  Created by Leopold Lemmermann on 25.10.22.

import Concurrency
import Errors
import LeosMisc
import SwiftUI

public typealias Loadable = DatabaseObjectConvertible

@propertyWrapper
public struct LoadedConvertibles<T: Loadable & Hashable, S: DatabaseService>: DynamicProperty  {
  public let query: Query<T>
  public var wrappedValue: [T] { get { .init(convertibles) } nonmutating set { convertibles = .init(newValue) } }
  public var projectedValue: Binding<[T]> { Binding { wrappedValue } set: { wrappedValue = $0 } }
  
  @State private var convertibles: IdentifiableSet<T>
  @EnvironmentObject private var service: S
  private let tasks = Tasks()
  
  public init(wrappedValue: [T] = [], _ query: Query<T>) {
    self.query = query
    _convertibles = State(initialValue: IdentifiableSet(wrappedValue))
  }
  
  public func update() {
    tasks["loadConvertibles"] = Task(priority: .userInitiated) { await load(query) }
    tasks["updateConvertibles"] = service.handleEventsTask(.userInitiated) { await update(on: $0) }
  }
  
  @MainActor private func load(_ query: Query<T>) async {
    await printError {
      convertibles.removeAll { !query.evaluate($0) }
      
      for try await convertibles in try await service.fetch(query) {
        for convertible in convertibles { self.convertibles.update(with: convertible) }
      }
    }
  }
    
  @MainActor private func update(on event: DatabaseEvent) async {
    await printError {
      switch event {
      case let .inserted(type, id) where type == T.self:
        if let id = id as? T.ID, let element: T = try await service.fetch(with: id), query.evaluate(element) {
          insert(element)
        }
      case let .deleted(type, id) where type == T.self:
        if let id = id as? T.ID { remove(with: id) }
      case let .status(status) where status == .unavailable:
        break
      case .status, .remote:
        tasks["loadConvertibles"] = Task(priority: .userInitiated) { await load(query) }
      default:
        break
      }
    }
  }
  
  private func remove(with id: T.ID) { convertibles[id] = nil }
  private func insert(_ element: T) { convertibles.update(with: element) }
}

@available(iOS 14, macOS 11, tvOS 14, watchOS 7, *)
@propertyWrapper
public struct CachedConvertibles<T: Loadable & Codable & Hashable, S: DatabaseService>: DynamicProperty  {
  public let query: Query<T>
  public var wrappedValue: [T] { get { .init(convertibles) } nonmutating set { convertibles = .init(newValue) } }
  public var projectedValue: Binding<[T]> { Binding { wrappedValue } set: { wrappedValue = $0 } }
  
  @ObjectSceneStorage private var convertibles: IdentifiableSet<T>
  @EnvironmentObject private var service: S
  private let tasks = Tasks()
  
  public init(wrappedValue: [T] = [], _ query: Query<T>, cacheID: String = UUID().uuidString) {
    self.query = query
    _convertibles = ObjectSceneStorage(wrappedValue: IdentifiableSet(wrappedValue), cacheID)
  }
  
  public func update() {
    tasks["loadConvertibles"] = Task(priority: .userInitiated) { await load(query) }
    tasks["updateConvertibles"] = service.handleEventsTask(.userInitiated) { await update(on: $0) }
  }
  
  @MainActor private func load(_ query: Query<T>) async {
    await printError {
      convertibles.removeAll { !query.evaluate($0) }
      
      for try await convertibles in try await service.fetch(query) {
        for convertible in convertibles { self.convertibles.update(with: convertible) }
      }
    }
  }
    
  @MainActor private func update(on event: DatabaseEvent) async {
    await printError {
      switch event {
      case let .inserted(type, id) where type == T.self:
        if let id = id as? T.ID, let convertible: T = try await service.fetch(with: id) {
          if query.evaluate(convertible) {
            insert(convertible)
          } else if convertibles.contains(with: convertible.id) {
            remove(with: id)
          }
        }
      case let .deleted(type, id) where type == T.self:
        if let id = id as? T.ID { remove(with: id) }
      case let .status(status) where status == .unavailable:
        break
      case .status, .remote:
        tasks["loadConvertibles"] = Task(priority: .userInitiated) { await load(query) }
      default:
        break
      }
    }
  }
  
  private func remove(with id: T.ID) { convertibles[id] = nil }
  private func insert(_ element: T) { convertibles.update(with: element) }
}
