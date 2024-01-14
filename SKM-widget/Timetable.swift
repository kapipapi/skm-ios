//
//  Timetable.swift
//  SKM-widgetExtension
//
//  Created by Kacper Ledwosiński on 14/01/2024.
//

import SwiftUI
import WidgetKit
import CoreLocation

struct Timetable: View {
    let rootUrl = "https://skmapp.ledwosinski.space"
    
    @StateObject var stopsView = StopsView()
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        VStack{
            Text(sortedStops.first?.stop_name ?? "loading")
        }
        .containerBackground(.fill.tertiary, for: .widget)
        .onAppear{
            stopsView.fetch(root: rootUrl)
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

struct Timetable_Previews: PreviewProvider {
    static var previews: some View {
        Timetable()
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
