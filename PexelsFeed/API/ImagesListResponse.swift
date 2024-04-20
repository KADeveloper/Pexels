//
//  ImagesListResponse.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/19/24.
//

import Foundation

struct ImagesListResponse: Decodable {
    let photos: [PhotoResponse]
    let nextPageUrl: URL?
    let page: Int

    enum CodingKeys: String, CodingKey {
        case photos
        case nextPageUrl = "next_page"
        case page
    }
}

struct PhotoResponse: Decodable {
    let photographer: String
    let averageColor: String
    let imageUrl: URL
    let width: Double
    let height: Double
    let id: Int

    enum CodingKeys: String, CodingKey {
        case photographer
        case averageColor = "avg_color"
        case width
        case height
        case id
        case src
    }

    enum SRCCodingKeys: String, CodingKey {
        case imageUrl = "medium"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.photographer = try container.decode(String.self, forKey: .photographer)
        self.averageColor = try container.decode(String.self, forKey: .averageColor)
        self.width = try container.decode(Double.self, forKey: .width)
        self.height = try container.decode(Double.self, forKey: .height)
        self.id = try container.decode(Int.self, forKey: .id)

        let src = try container.nestedContainer(keyedBy: SRCCodingKeys.self, forKey: .src)
        self.imageUrl = try src.decode(URL.self, forKey: .imageUrl)
    }
}
