//
//  DayOfChoiceWidgetLiveActivity.swift
//  DayOfChoiceWidget
//
//  Created by TAIGA ITO on 2024/05/27.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct DayOfChoiceWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct DayOfChoiceWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: DayOfChoiceWidgetAttributes.self) { context in
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

extension DayOfChoiceWidgetAttributes {
    fileprivate static var preview: DayOfChoiceWidgetAttributes {
        DayOfChoiceWidgetAttributes(name: "World")
    }
}

extension DayOfChoiceWidgetAttributes.ContentState {
    fileprivate static var smiley: DayOfChoiceWidgetAttributes.ContentState {
        DayOfChoiceWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: DayOfChoiceWidgetAttributes.ContentState {
         DayOfChoiceWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: DayOfChoiceWidgetAttributes.preview) {
   DayOfChoiceWidgetLiveActivity()
} contentStates: {
    DayOfChoiceWidgetAttributes.ContentState.smiley
    DayOfChoiceWidgetAttributes.ContentState.starEyes
}
