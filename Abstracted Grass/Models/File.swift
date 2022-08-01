//
//  AbstractedGrassFile.swift
//  Abstracted Grass
//
//  Created by Anthony Li on 8/1/22.
//

import Foundation
import MapKit

enum MapType: Codable {
    case standard
    case muted
    case hybrid
    case satellite
    
    var supportsPOIFilters: Bool {
        self != .satellite
    }
    
    var supportsTraffic: Bool {
        self != .satellite
    }
    
    var supportsAppearance: Bool {
        self == .standard || self == .muted
    }
}

struct MapSettings: Codable {
    var type = MapType.standard
    var elevation = true
    var traffic = false
    var forceLight = false
    var poiFilter: Set<String>?
    
    static let otherPOIFilter = "dev.anli.abstractedgrass.poicategory.other"
    
    func generatePOIFilter() -> MKPointOfInterestFilter? {
        poiFilter.map { items in
            if items.contains(MapSettings.otherPOIFilter) {
                return MKPointOfInterestFilter(excluding: filters.filter { !items.contains($0.0.rawValue) }.map { $0.0 })
            } else {
                return MKPointOfInterestFilter(including: items.map { MKPointOfInterestCategory(rawValue: $0) })
            }
        }
    }
    
    func generateConfiguration() -> MKMapConfiguration {
        let elevationStyle: MKMapConfiguration.ElevationStyle = elevation ? .realistic : .flat
        switch type {
        case .standard, .muted:
            let configuration = MKStandardMapConfiguration(elevationStyle: elevationStyle, emphasisStyle: type == .muted ? .muted : .default)
            configuration.showsTraffic = traffic
            configuration.pointOfInterestFilter = generatePOIFilter()
            return configuration
        case .hybrid:
            let configuration = MKHybridMapConfiguration(elevationStyle: elevationStyle)
            configuration.showsTraffic = traffic
            configuration.pointOfInterestFilter = generatePOIFilter()
            return configuration
        case .satellite:
            return MKImageryMapConfiguration(elevationStyle: elevationStyle)
        }
    }
}

struct AbstractedGrassFile: Codable, MigratableFile {
    static let versionString = "1"
    private(set) var version = AbstractedGrassFile.versionString
    
    var settings = MapSettings()
    var fps: Int = 30
    var length: Int = 300
    
    func migrate() -> AbstractedGrassFile {
        self
    }
}
