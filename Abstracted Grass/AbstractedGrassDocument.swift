//
//  Abstracted_GrassDocument.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var abstractedGrassFile: UTType {
        UTType(importedAs: "dev.anli.abstractedgrass.file")
    }
}

struct AbstractedGrassDocument: FileDocument {
    var file: AbstractedGrassFile

    init() {
        file = AbstractedGrassFile()
    }

    static var readableContentTypes: [UTType] { [.abstractedGrassFile] }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        do {
            file = try migrate(data: data, using: fileFormats)
        } catch let error {
            print(error)
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        precondition(file.version == AbstractedGrassFile.versionString)
        let data = try JSONEncoder.default.encode(file)
        return .init(regularFileWithContents: data)
    }
}
