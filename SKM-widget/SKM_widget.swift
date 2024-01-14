//
//  SKM_widget.swift
//  SKM-widget
//
//  Created by Kacper Ledwosiński on 14/01/2024.
//

import SwiftUI
import WidgetKit
import CoreLocation

enum MyError: Error {
    case runtimeError(String)
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), nextUpdate: Date(), stop: .test, routes: [.test])
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), nextUpdate: Date(), stop: .test, routes: [.test])
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        
        let rootUrl = "https://skmapp.ledwosinski.space"
        
        let locationDataManager = LocationDataManager()
        
        let date = Calendar.current.date(byAdding: .minute, value: 5, to: Date())!
        
        do {
            let stopList = try await StopsView.fetchStopsList(root: rootUrl)
            
            var entries: [SimpleEntry] = []
            
            if !stopList.isEmpty {
                let nearestStop: Stop
                
                if locationDataManager.locationManager.location != nil {
                    let sorted = sortStops(stops: stopList, location: locationDataManager.locationManager.location)
                    nearestStop = sorted.first!
                } else {
                    print("Location not found, getting stop from Widget configuration.")
                    nearestStop = stopList.first(where: {$0.stop_id == configuration.nearestStopManual.id})!
                }
                
                let n_results = switch context.family {
                    case .systemSmall: 1;
                    case .systemMedium: 2;
                    case .systemLarge: 7;
                    default: 1;
                }
                
                let routes = try await RoutesView.fetchRoutesList(root: rootUrl, id: nearestStop.stop_id, n: n_results)
                
                entries.append(SimpleEntry(date: Date(), nextUpdate: date, stop: nearestStop, routes: routes))
            }

            return Timeline(entries: entries, policy: .after(date))
        } catch {
            return Timeline(entries: [], policy: .after(date))
        }
    }
}

struct SimpleEntry: TimelineEntry {
    var date: Date
    let nextUpdate: Date
    let stop: Stop
    let routes: [Route]
}

extension Route {
    fileprivate static var test: Route {
        return Route(trip_headsign: "Gdańsk Śródmieście", arrival_datetime: Date())
    }
}

extension Stop {
    fileprivate static var test: Stop {
        return Stop(stop_id: "0", stop_name: "Gdańsk Wrzeszcz", stop_lat: 0.0, stop_lon: 0.0, wheelchair_boarding: 0)
    }
}

struct SKM_widgetEntryView: View {
    var entry: Provider.Entry
    
    func formatTimeInterval(startDate: Date, endDate: Date) -> String {
        let interval = endDate.timeIntervalSince(startDate)
                
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute]
        formatter.unitsStyle = .brief
        
        return formatter.string(from: interval) ?? ""
    }
    
    var body: some View {
        VStack{
            HStack{
                Text(entry.stop.stop_name)
                    .font(.subheadline)
                    .padding(.bottom, 2)
            }
            ForEach(entry.routes, id: \.self) { route in
                HStack{
                    VStack(alignment: .leading) {
                        Text(route.trip_headsign)
                            .font(.subheadline)
                        Text(route.arrival_datetime, style: .time)
                            .font(.caption)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(formatTimeInterval(startDate: entry.date, endDate: route.arrival_datetime))
                        .multilineTextAlignment(.trailing)
                        .font(.title3)
                }
                .padding(.bottom, 2)
            }
            Spacer()
        }
        .containerBackground(.fill.tertiary, for: .widget)
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

struct SKM_widget: Widget {
    let kind: String = "SKM_widget"

    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            SKM_widgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
    }
}

#Preview(as: .systemLarge) {
    SKM_widget()
} timeline: {
    SimpleEntry(date: .now, nextUpdate: .now, stop: .test, routes: [.test, .test, .test, .test, .test, .test, .test])
}
