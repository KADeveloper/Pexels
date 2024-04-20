//
//  LoadingErrorView.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/20/24.
//

import SwiftUI

struct LoadingErrorView: View {
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Text("Oops! Something went wrong")
                .foregroundStyle(.red)
                .font(.body)

            Button(
                action: {
                    retryAction()
                }, label: {
                    Text("Retry")
                        .foregroundStyle(.blue)
                        .font(.body)
                        .fontWeight(.bold)
                        .underline()
                }
            )
        }
    }
}
