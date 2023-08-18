//
//  PrimaryKeyType.swift
//  
//
//  Created by Rza Ismayilov on 18.08.23.
//

import Foundation

public protocol PrimaryKeyType: Equatable {
    var raw: String { get }
}

extension Int: PrimaryKeyType {
    public var raw: String { self.description }
}

extension UUID: PrimaryKeyType {
    public var raw: String { self.uuidString }
}

extension String: PrimaryKeyType {
    public var raw: String { self }
}
