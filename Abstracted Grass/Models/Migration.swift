//
//  Migration.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import Foundation

protocol MigratableFile<Final>: Decodable {
    associatedtype Final
    
    func migrate() throws -> Final
    
    static var versionString: String { get }
    var version: String { get }
}

struct VersionedFile: Decodable {
    var version: String
}

enum FileMigrationError: Error {
    case unknownVersion(String)
}

func migrate<Final>(data: Data, using formats: [any MigratableFile<Final>.Type]) throws -> Final {
    let decoder = JSONDecoder.default
    let version = try decoder.decode(VersionedFile.self, from: data).version
    
    guard let format = formats.first(where: { $0.versionString == version }) else {
        throw FileMigrationError.unknownVersion(version)
    }
    
    let decoded = try decoder.decode(format, from: data)
    return try decoded.migrate()
}

struct BlankFile: MigratableFile {
    static let versionString = ""
    private(set) var version = BlankFile.versionString
    
    func migrate() -> AbstractedGrassFile {
        AbstractedGrassFile()
    }
}

let fileFormats: [any MigratableFile<AbstractedGrassFile>.Type] = [
    AbstractedGrassFile.self,
    BlankFile.self
]
