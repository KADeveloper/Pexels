//
//  Navigation+BackButton.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/20/24.
//

import SwiftUI

extension View {
    func navigationBackButton(color: Color) -> some View {
        modifier(NavigationBackButton(backButtonColor: color))
    }
}

private struct NavigationBackButton: ViewModifier {
    @Environment(\.dismiss) var dismiss

    let backButtonColor: Color

    func body(content: Content) -> some View {
        return content
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button(
                        action: {
                            dismiss()
                        },
                        label: {
                            Image(systemName: "chevron.backward")
                                .renderingMode(.template)
                                .foregroundStyle(backButtonColor)

                            Text("Back")
                                .font(.headline)
                                .foregroundColor(backButtonColor)
                        }
                    )
                }
            }
    }
}
