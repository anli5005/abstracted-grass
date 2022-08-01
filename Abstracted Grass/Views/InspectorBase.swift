//
//  InspectorBase.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import SwiftUI

struct InspectorBase<Content: View, Header: View>: View {
    var content: Content
    var header: Header
    
    init(@ViewBuilder _ content: () -> Content, @ViewBuilder header: () -> Header) {
        self.content = content()
        self.header = header()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header.fontWeight(.bold).font(.title3).padding().frame(maxWidth: .infinity)
            Divider()
            content.frame(maxHeight: .infinity, alignment: .top)
        }
    }
}

struct InspectorBase_Previews: PreviewProvider {
    static var previews: some View {
        InspectorBase {
            Text("Inspector content")
        } header: {
            Text("Preview")
        }
    }
}
