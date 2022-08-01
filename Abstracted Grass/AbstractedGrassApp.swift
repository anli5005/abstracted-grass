//
//  Abstracted_GrassApp.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import SwiftUI

@main
struct AbstractedGrassApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: AbstractedGrassDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
