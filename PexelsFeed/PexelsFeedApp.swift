//
//  PexelsFeedApp.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/19/24.
//

import SwiftUI

@main
struct PexelsFeedApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ImagesListView(viewModel: ImagesListViewModel())
            }
        }
    }
}
