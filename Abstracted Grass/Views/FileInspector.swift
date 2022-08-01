//
//  FileInspector.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import SwiftUI
import MapKit

struct POIFilterSettings: View {
    @Binding var poiFilter: Set<String>?
    
    var body: some View {
        VStack(alignment: .leading) {
            Toggle("Filter POIs", isOn: Binding {
                poiFilter != nil
            } set: { value in
                if value && poiFilter == nil {
                    poiFilter = []
                }
                
                if !value {
                    poiFilter = nil
                }
            }).toggleStyle(SwitchToggleStyle()).fontWeight(.bold)
            if poiFilter != nil {
                VStack(spacing: 0) {
                    Button(poiFilter!.count == (filters.count + 1) ? "Deselect All" : "Select All") {
                        if poiFilter!.count == (filters.count + 1) {
                            poiFilter = []
                        } else {
                            poiFilter = Set(filters.map { $0.0.rawValue } + [MapSettings.otherPOIFilter])
                        }
                    }.padding()
                    Divider()
                    ScrollView {
                        LazyVStack(alignment: .leading) {
                            ForEach(filters, id: \.0) { filter in
                                Toggle(filter.1, isOn: Binding {
                                    poiFilter!.contains(filter.0.rawValue)
                                } set: { value in
                                    if value {
                                        poiFilter!.insert(filter.0.rawValue)
                                    } else {
                                        poiFilter!.remove(filter.0.rawValue)
                                    }
                                })
                            }
                            Divider()
                            Toggle("Other", isOn: Binding {
                                poiFilter!.contains(MapSettings.otherPOIFilter)
                            } set: { value in
                                if value {
                                    poiFilter!.insert(MapSettings.otherPOIFilter)
                                } else {
                                    poiFilter!.remove(MapSettings.otherPOIFilter)
                                }
                            })
                        }.padding()
                    }
                }.frame(width: 200, height: 500).overlay(RoundedRectangle(cornerRadius: 4).stroke(.separator))
            }
        }.padding()
    }
}

struct FileInspector: View {
    @Binding var file: AbstractedGrassFile
    @State var showingPOIFilters = false
    
    static let fpsFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        formatter.minimum = 1
        formatter.maximum = 300
        return formatter
    }()
    
    static let lengthFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.allowsFloats = false
        formatter.minimum = 1
        return formatter
    }()
    
    var body: some View {
        InspectorBase {
            Form {
                Section("Map") {
                    Picker("Type", selection: $file.settings.type) {
                        Text("Standard").tag(MapType.standard)
                        Text("Muted").tag(MapType.muted)
                        Divider()
                        Text("Hybrid").tag(MapType.hybrid)
                        Text("Satellite").tag(MapType.satellite)
                    }
                    Picker("Elevation Style", selection: $file.settings.elevation) {
                        Text("Flat").tag(false)
                        Text("Realistic").tag(true)
                    }
                    if file.settings.type.supportsTraffic {
                        Toggle("Show Traffic", isOn: $file.settings.traffic)
                    }
                    if file.settings.type.supportsAppearance {
                        Toggle("Force Light Mode", isOn: $file.settings.forceLight)
                    }
                    if file.settings.type.supportsPOIFilters {
                        Button(file.settings.poiFilter == nil ? "Filter POIs..." : "\(file.settings.poiFilter!.count) POI(s) selected") {
                            showingPOIFilters = true
                        }.popover(isPresented: $showingPOIFilters, arrowEdge: .trailing) {
                            POIFilterSettings(poiFilter: $file.settings.poiFilter)
                        }
                    }
                }
                
                Spacer().frame(height: 32)
                
                Section("Animation") {
                    TextField("# of Frames", value: $file.length, formatter: Self.lengthFormatter)
                    TextField("Frames per Second", value: $file.fps, formatter: Self.fpsFormatter)
                    Text("~\(file.length / file.fps) second(s)").font(.caption).foregroundColor(.secondary)
                }
            }.padding()
        } header: {
            Text("File")
        }
    }
}

struct FileInspector_Previews: PreviewProvider {
    static var previews: some View {
        FileInspector(file: .constant(AbstractedGrassFile()))
    }
}
