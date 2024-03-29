//
//  ContentView.swift
//  SKMApp
//
//  Created by Kacper Ledwosiński on 13/01/2024.
//

import SwiftUI
import CoreLocation

struct ContentView: View {
    let rootUrl = "https://skmapp.ledwosinski.space"
    
    @StateObject var stopsView = StopsView()
    @StateObject var locationDataManager = LocationDataManager()

    var body: some View {
        NavigationView{
            List{
                ForEach(sortedStops){stop in
                    NavigationLink(destination: TimetableForStop(stopName: .constant(stop.stop_name), stopId: .constant(stop.stop_id))){
                        Text(stop.stop_name)
                    }
                }
            }
            .navigationTitle("Przystanki")
            .onAppear{
                stopsView.fetch(root: rootUrl)
            }
        }
    }
    
    private var sortedStops: [Stop] {
        if let currentLocation = locationDataManager.locationManager.location {
            return stopsView.stops.sorted {
                let loc1 = CLLocation(latitude: $0.stop_lat, longitude: $0.stop_lon)
                let loc2 = CLLocation(latitude: $1.stop_lat, longitude: $1.stop_lon)
                return currentLocation.distance(from: loc1) < currentLocation.distance(from: loc2)
            }
        } else {
            return stopsView.stops
        }
    }
}

#Preview {
    ContentView()
}
