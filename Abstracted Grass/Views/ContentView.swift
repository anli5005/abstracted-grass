//
//  ContentView.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: AbstractedGrassDocument
    @State var currentFrame = 0
    @State var playStart: Date?
    @State var loop = false
    
    func getEffectiveFrame(offset: TimeInterval = 0) -> Int {
        return currentFrame + Int(Double(offset) * Double(document.file.fps))
    }
    
    func togglePlay() {
        if let playStart = playStart {
            self.playStart = nil
            currentFrame = min(getEffectiveFrame(offset: Date().timeIntervalSince(playStart)), document.file.length - 1)
        } else {
            if currentFrame >= document.file.length - 1 {
                currentFrame = 0
            }
            playStart = Date()
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                FileInspector(file: $document.file).frame(width: 400)
                Divider()
                VStack(spacing: 0) {
                    MapView(settings: document.file.settings).frame(minWidth: 400, maxWidth: .infinity, maxHeight: .infinity)
                    Divider()
                    HStack {
                        Button {
                            togglePlay()
                        } label: {
                            Image(systemName: playStart == nil ? "play.fill" : "pause.fill")
                        }.buttonStyle(PlainButtonStyle())
                        TimelineView(.animation(paused: playStart == nil), content: { context in
                            let frame = getEffectiveFrame(offset: playStart == nil ? 0 : context.date.timeIntervalSince(playStart!))
                            Text("\(frame)").font(.title.monospacedDigit()).onChange(of: frame) { frame in
                                if playStart != nil {
                                    if frame >= document.file.length {
                                        if loop {
                                            currentFrame = 0
                                            playStart = context.date
                                        } else {
                                            currentFrame = document.file.length - 1
                                            playStart = nil
                                        }
                                    }
                                }
                            }
                        })
                        Button {
                            loop.toggle()
                        } label: {
                            Image(systemName: "repeat").foregroundColor(loop ? .accentColor : .primary)
                        }.buttonStyle(PlainButtonStyle())
                    }.font(.title.monospacedDigit()).padding()
                }
            }.frame(minHeight: 400)
            Divider()
            Text("Timeline").frame(height: 300)
        }.onChange(of: document.file.fps) { _ in
            if playStart != nil {
                playStart = nil
            }
        }.onChange(of: document.file.length) { length in
            if let playStart = playStart {
                let frame = getEffectiveFrame(offset: Date().timeIntervalSince(playStart))
                if frame >= document.file.length {
                    if loop {
                        currentFrame = 0
                        self.playStart = Date()
                    } else {
                        currentFrame = document.file.length - 1
                        self.playStart = nil
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(document: .constant(AbstractedGrassDocument()))
    }
}
