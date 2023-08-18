//
//  FlyingError.swift
//  
//
//  Created by Rza Ismayilov on 19.08.23.
//

import Foundation

enum FlyingError: Error, Equatable {
    case fileAlreadyExist(atPath: String)
    case fileCreationFailed(atPath: String)
    case fileNotFound(atPath: String)
    case writeAttemptOutOfTransactionBlock
    case schemaMismatch(version: Int)
}
