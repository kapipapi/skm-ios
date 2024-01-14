//
//  AppIntent.swift
//  SKM-widget
//
//  Created by Kacper Ledwosiński on 14/01/2024.
//

import WidgetKit
import AppIntents

enum StopToSelect: String, AppEnum {
    case srodmiescie, glowny, stocznia, wrzeszcz, zaspa, przymorze, sopot

    var id: String {
        return switch self{
            case .srodmiescie: "258458"
            case .glowny: "7500"
            case .stocznia: "7518"
            case .wrzeszcz: "7534"
            case .zaspa: "7559"
            case .przymorze: "7567"
            case .sopot: "5942"
        }
    }

    static var typeDisplayRepresentation: TypeDisplayRepresentation = "Stop"
    static var caseDisplayRepresentations: [StopToSelect : DisplayRepresentation] = [
        .srodmiescie: "Śródmieście",
        .glowny: "Główny",
        .stocznia: "Stocznia",
        .wrzeszcz: "Wrzeszcz",
        .zaspa: "Zaspa",
        .przymorze: "Przymorze",
        .sopot: "Sopot",
    ]
}

struct ConfigurationAppIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "SKM Nearest Stop"
    static var description = IntentDescription("Widget display nearest SKM station name.")
    
    @Parameter(title: "Stacja", default: .wrzeszcz)
    var nearestStopManual: StopToSelect
}
