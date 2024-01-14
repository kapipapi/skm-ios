//
//  ViewModel.swift
//  SKMApp
//
//  Created by Kacper Ledwosiński on 13/01/2024.
//

import Foundation
import SwiftUI

struct Route: Hashable, Codable {
    let trip_headsign: String
    let arrival_datetime: Date
}

class RoutesView: ObservableObject {
    @Published var routes: [Route] = []
    
    func fetch(root: String, id: String) {
        guard let url = URL(string: "\(root)/stop/\(id)/10") else {return}
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .millisecondsSince1970

                let routes = try decoder.decode([Route].self, from: data)
                DispatchQueue.main.async {
                    self?.routes = routes
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    static func fetchRoutesList(root: String, id: String, n: Int) async throws -> [Route] {
        let url = URL(string: "\(root)/stop/\(id)/\(n)")!

        let (data, _) = try await URLSession.shared.data(from: url)

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .millisecondsSince1970

        let routes = try decoder.decode([Route].self, from: data)
        
        return routes
    }
}
