//
//  SKM_widgetLiveActivity.swift
//  SKM-widget
//
//  Created by Kacper Ledwosiński on 14/01/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct SKM_widgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct SKM_widgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: SKM_widgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension SKM_widgetAttributes {
    fileprivate static var preview: SKM_widgetAttributes {
        SKM_widgetAttributes(name: "World")
    }
}

extension SKM_widgetAttributes.ContentState {
    fileprivate static var smiley: SKM_widgetAttributes.ContentState {
        SKM_widgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: SKM_widgetAttributes.ContentState {
         SKM_widgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: SKM_widgetAttributes.preview) {
   SKM_widgetLiveActivity()
} contentStates: {
    SKM_widgetAttributes.ContentState.smiley
    SKM_widgetAttributes.ContentState.starEyes
}
