//
//  LoadingView.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/20/24.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 32) {
            Text("Please wait")

            HStack {
                Text("Loading images")

                TimelineView(.animation(minimumInterval: 1, paused: false)) { context in
                    let dotsText = calculateDotsText(basedOn: context.date)
                    Text(dotsText)
                }
            }
        }
        .foregroundStyle(.blue)
        .font(.headline)
        .fontWeight(.medium)
    }

    private func calculateDotsText(basedOn date: Date) -> String {
        let calendar = Calendar.current
        let dotsCount = calendar.component(.second, from: date) % 3

        if dotsCount == 1 {
            return ".  "
        } else if dotsCount == 2 {
            return ".. "
        } else {
            return "..."
        }
    }
}
