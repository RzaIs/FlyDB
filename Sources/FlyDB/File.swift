//
//  File.swift
//  
//
//  Created by Rza Ismayilov on 19.08.23.
//

import Foundation

fileprivate let fileManager = FileManager.default

func fileExist(at path: String) -> Bool {
    var isDir: ObjCBool = false
    return fileManager.fileExists(atPath: path, isDirectory: &isDir)
}

func createFile(at path: String, with content: Data? = nil) -> Result<Void, Error> {
    if fileExist(at: path) {
        return .failure(FlyingError.fileAlreadyExist(atPath: path))
    }
    if fileManager.createFile(atPath: path, contents: content) {
        return .success(Void())
    } else {
        return .failure(FlyingError.fileCreationFailed(atPath: path))
    }
}

func createFiles(at path: String, with nameAndContents: [(String, Data?)]) -> Result<Void, Error> {
    for (name, content) in nameAndContents {
        let filePath = path + name
        if fileExist(at: filePath) {
            return .failure(FlyingError.fileAlreadyExist(atPath: filePath))
        }
        guard fileManager.createFile(atPath: filePath, contents: content) else {
            return .failure(FlyingError.fileCreationFailed(atPath: filePath))
        }
    }
    return .success(Void())
}

func contentsofFile(at path: String) -> Result<Data, Error> {
    guard fileExist(at: path) else {
        return .failure(FlyingError.fileNotFound(atPath: path))
    }

    guard let contents = fileManager.contents(atPath: path) else {
        return .failure(FlyingError.fileNotFound(atPath: path))
    }
    return .success(contents)
}

func contentsofFiles(at path: String) -> Result<[Data], Error> {
    guard directoryExist(at: path) else {
        return .success([])
    }

    let fileNames: [String]

    do {
        fileNames = try fileManager.contentsOfDirectory(atPath: path)
    } catch {
        return .failure(error)
    }

    let contents = fileNames.map { name in
        fileManager.contents(atPath: path + "/" + name)
    }.compactMap { $0 }

    return .success(contents)
}
