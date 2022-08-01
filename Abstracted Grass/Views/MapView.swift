//
//  MapView.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import MapKit
import SwiftUI

struct MapView: NSViewRepresentable {
    var settings: MapSettings
    
    func makeNSView(context: Context) -> MKMapView {
        let view = MKMapView()
        updateNSView(view, context: context)
        return view
    }
    
    func updateNSView(_ view: MKMapView, context: Context) {
        view.preferredConfiguration = settings.generateConfiguration()
        if settings.forceLight {
            view.appearance = NSAppearance(named: .aqua)
        } else {
            view.appearance = NSApp.appearance
        }
    }
}
