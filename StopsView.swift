//
//  StopsView.swift
//  SKMApp
//
//  Created by Kacper Ledwosiński on 13/01/2024.
//

import Foundation
import SwiftUI
import CoreLocation

struct Stop: Identifiable, Hashable, Codable {
    let stop_id: String
    let stop_name: String
    let stop_lat: Double
    let stop_lon: Double
    let wheelchair_boarding: Int
    
    var id: String { stop_id }
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D.init(
            latitude: stop_lat,
            longitude: stop_lon
        )
    }
}

class StopsView: ObservableObject {
    @Published var stops: [Stop] = []

    func fetch(root: String) {
        guard let url = URL(string: "\(root)/") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let stops = try JSONDecoder().decode([Stop].self, from: data)
                DispatchQueue.main.async {
                    self?.stops = stops
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    static func fetchStopsList(root: String) async throws -> [Stop] {
        let url = URL(string: "\(root)/")!

        let (data, _) = try await URLSession.shared.data(from: url)

        let stops = try JSONDecoder().decode([Stop].self, from: data)
        
        return stops
    }
}

func sortStops(stops: [Stop], location: CLLocation?) -> [Stop] {
    if let currentLocation = location {
        return stops.sorted {
            let loc1 = CLLocation(latitude: $0.stop_lat, longitude: $0.stop_lon)
            let loc2 = CLLocation(latitude: $1.stop_lat, longitude: $1.stop_lon)
            return currentLocation.distance(from: loc1) < currentLocation.distance(from: loc2)
        }
    } else {
        return stops
    }
}
