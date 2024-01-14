//
//  TimetableForStop.swift
//  SKMApp
//
//  Created by Kacper Ledwosiński on 13/01/2024.
//

import Foundation
import SwiftUI

struct TimetableForStop: View {
    let rootUrl = "https://skmapp.ledwosinski.space"
    
    @Binding var stopName: String
    @Binding var stopId: String

    @StateObject var routesView = RoutesView()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(routesView.routes, id: \.self) { route in
                    HStack{
                        Text(route.trip_headsign)
                        Spacer()
                        Text(route.arrival_datetime.formatted(date: .omitted, time: .shortened))
                    }
                }
            }
            .navigationTitle(stopName)
            .onAppear{
                routesView.fetch(root: rootUrl, id: stopId)
            }
        }
    }
}


#Preview {
    TimetableForStop(stopName: .constant("Gdańsk Przymorze-Uniwer."), stopId: .constant("7567"))
}
