//
//  MessageBoxControl.swift
//  MessageBox
//
//  Created by Thang Nguyen on 11/7/25.
//

import WidgetKit
import SwiftUI

struct MessageBoxControlProvider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleControlEntry {
        SimpleControlEntry(date: Date(), isRunning: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleControlEntry) -> ()) {
        let entry = SimpleControlEntry(date: Date(), isRunning: false)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleControlEntry>) -> ()) {
        let entry = SimpleControlEntry(date: Date(), isRunning: false)
        let timeline = Timeline(entries: [entry], policy: .never)
        completion(timeline)
    }
}

struct SimpleControlEntry: TimelineEntry {
    let date: Date
    let isRunning: Bool
}

struct MessageBoxControlEntryView: View {
    var entry: MessageBoxControlProvider.Entry
    
    var body: some View {
        VStack {
            Image(systemName: "timer")
                .font(.title2)
                .foregroundColor(entry.isRunning ? .green : .gray)
            
            Text(entry.isRunning ? "Running" : "Stopped")
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
}

struct MessageBoxControl: Widget {
    let kind: String = "MessageBoxControl"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: MessageBoxControlProvider()) { entry in
            MessageBoxControlEntryView(entry: entry)
                .padding()
                .background(Color(.systemBackground))
        }
        .configurationDisplayName("Timer Control")
        .description("A simple timer control widget.")
    }
}
