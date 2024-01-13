//
//  StopsView.swift
//  SKMApp
//
//  Created by Kacper Ledwosiński on 13/01/2024.
//

import Foundation
import SwiftUI

struct Stop: Identifiable, Hashable, Codable {
    let stop_id: String
    let stop_name: String
    let stop_lat: Float
    let stop_lon: Float
    let wheelchair_boarding: Int
    
    var id: String { stop_id }
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
}
