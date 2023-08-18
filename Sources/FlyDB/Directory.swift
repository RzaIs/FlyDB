//
//  Directory.swift
//  
//
//  Created by Rza Ismayilov on 19.08.23.
//

import Foundation

fileprivate let fileManager = FileManager.default

func createDirectoryIfDoesNotExist(at path: String) -> Result<Void, Error> {
    if directoryExist(at: path) { return .success(()) }
    do {
        return .success(
            try fileManager.createDirectory(atPath: path, withIntermediateDirectories: true)
        )
    } catch {
        return .failure(error)
    }
}

func directoryExist(at path: String) -> Bool {
    var isDir: ObjCBool = true
    return fileManager.fileExists(atPath: path, isDirectory: &isDir)
}
