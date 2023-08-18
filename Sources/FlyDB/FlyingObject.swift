//
//  FlyingObject.swift
//  
//
//  Created by Rza Ismayilov on 18.08.23.
//

import Foundation

fileprivate let encoder: JSONEncoder = .init()
fileprivate let decoder: JSONDecoder = .init()

public protocol FlyingObject: Codable, Equatable {
    associatedtype PrimaryKey: PrimaryKeyType

    static var collection: String { get }

    var primaryKey: PrimaryKey { get }
}

extension FlyingObject {
    func encode() -> Data? {
        return try? encoder.encode(self)
            .base64EncodedData()
    }
}

extension Data {
    func decode<T: FlyingObject>() -> T? {
        guard let data = Data(base64Encoded: self) else { return nil }
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            if (error as? DecodingError) != nil {
                fatalError(
                    FlyingError.schemaMismatch(
                        version: currentSchemaVersion()
                    ).localizedDescription
                )
            } else { return nil }
        }
    }
}
