//
//  ContentView.swift
//  SKMApp
//
//  Created by Kacper Ledwosiński on 13/01/2024.
//

import SwiftUI

struct ContentView: View {
    let rootUrl = "http://localhost:8800"
    
    @StateObject var stopsView = StopsView()
    
    var body: some View {
        NavigationView{
            List{
                ForEach(stopsView.stops){stop in
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
}

#Preview {
    ContentView()
}
