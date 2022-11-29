//	Created by Leopold Lemmermann on 29.11.22.

import class Combine.PassthroughSubject
@_exported import Foundation
@_exported import Queries
@_exported import Queries_KeyPath

public typealias DidChangePublisher = PassthroughSubject<RemoteDatabaseChange, Never>
