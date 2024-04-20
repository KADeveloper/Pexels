//
//  ImagesListViewModel.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/19/24.
//

import Foundation
import Dependencies

final class ImagesListViewModel: ObservableObject {
    private let networking: Networking

    private var nextPage: Int = 1

    @Published var state = State()

    init() {
        @Dependency(\.di) var di: DependenciesContainerProtocol
        networking = di.networking
    }

    func handleViewAction(_ action: ViewAction) {
        switch action {
        case .loadMoreImages:
            guard state.loadingState != .loading else { return }
            fetchImages()

        case .refreshImages:
            state.images = []
            nextPage = 1
            fetchImages()
        }
    }

    private func fetchImages() {
        state.loadingState = .loading
        Task { @MainActor in
            try await Task.sleep(for: .seconds(1))

            do {
                let response = try await networking.loadImages(page: nextPage)
                mapImages(from: response)
            } catch {
                state.loadingState = .error
            }
        }
    }

    private func mapImages(from response: ImagesListResponse) {
        state.loadingState = .idle

        guard !response.photos.isEmpty else {
            state.canLoadMore = false
            return
        }

        let images = response.photos.map {
            ImageModel(
                author: $0.photographer,
                averageHexColor: $0.averageColor,
                imageUrl: $0.imageUrl,
                width: $0.width,
                height: $0.height,
                page: response.page
            )
        }

        state.images += images

        guard let nextPageUrl = response.nextPageUrl,
              let urlComponents = URLComponents(url: nextPageUrl, resolvingAgainstBaseURL: true),
              let queryItems = urlComponents.queryItems,
              let pageValue = queryItems.first(where: { $0.name == "page" })?.value,
              let nextPage = Int(pageValue) else {
            state.canLoadMore = false
            return
        }

        self.nextPage = nextPage
        state.canLoadMore = true
    }
}

extension ImagesListViewModel {
    enum LoadingState {
        case loading
        case idle
        case error
    }

    enum ViewAction {
        case loadMoreImages
        case refreshImages
    }

    struct State {
        var images: [ImageModel] = []
        var loadingState: LoadingState = .idle
        var canLoadMore: Bool = true
    }
}
