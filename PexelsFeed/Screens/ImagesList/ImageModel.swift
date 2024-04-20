//
//  ImageModel.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/19/24.
//

import Foundation

struct ImageModel: Identifiable {
    let id = UUID().uuidString
    let author: String
    let averageHexColor: String
    let imageUrl: URL
    let width: Double
    let height: Double
    let page: Int
}
