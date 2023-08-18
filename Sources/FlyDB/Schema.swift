//
//  File 2.swift
//  
//
//  Created by Rza Ismayilov on 19.08.23.
//

import Foundation

fileprivate let encoder: JSONEncoder = .init()
fileprivate let decoder: JSONDecoder = .init()

fileprivate struct SchemaFile: Codable {
    let version: Int

    func encode() -> Data? {
        try? encoder.encode(self)
    }
}

fileprivate extension Data {
    func decodeSchemaFile() -> SchemaFile? {
        try? decoder.decode(SchemaFile.self, from: self)
    }
}

func save(schemaVersion: Int) {
    guard let content = SchemaFile(version: schemaVersion).encode()
    else { return }
    let path = "fly_db/schema.json"
    if fileExist(at: path) {
        try? FileManager.default.removeItem(atPath: "fly_db/schema.json")
    }
    FileManager.default.createFile(atPath: "fly_db/schema.json", contents: content)
}

func currentSchemaVersion() -> Int {
    guard let content = FileManager.default.contents(atPath: "fly_db/schema.json")
    else { return 1 }
    guard let schema = content.decodeSchemaFile() else {
        save(schemaVersion: 1)
        return 1
    }
    return schema.version
}
