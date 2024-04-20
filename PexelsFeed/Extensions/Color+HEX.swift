//
//  Color+HEX.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/20/24.
//

import SwiftUI

extension Color {
    init(hex: String) {
        let cleanHexCode = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0

        Scanner(string: cleanHexCode).scanHexInt64(&rgb)

        let redValue = Double((rgb >> 16) & 0xFF) / 255.0
        let greenValue = Double((rgb >> 8) & 0xFF) / 255.0
        let blueValue = Double(rgb & 0xFF) / 255.0

        self.init(red: redValue, green: greenValue, blue: blueValue)
    }

    var isBright: Bool {
        guard let components = cgColor?.components else { return false }

        let redBrightness = components[0] * 299
        let greenBrightness = components[1] * 587
        let blueBrightness = components[2] * 114
        let brightness = (redBrightness + greenBrightness + blueBrightness) / 1000
        return brightness > 0.5
    }
}
