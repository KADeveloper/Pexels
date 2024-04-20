//
//  ImagesListView.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/19/24.
//

import SwiftUI
import Kingfisher

struct ImagesListView: View {
    @StateObject private var viewModel: ImagesListViewModel

    init(viewModel: ImagesListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        ZStack {
            if viewModel.state.images.isEmpty {
                switch viewModel.state.loadingState {
                case .loading:
                    LoadingView()

                case .idle:
                    VStack(spacing: 32) {
                        Image(.sadIcon)

                        Text("No images found")

                        Text("Check back again later")
                    }
                    .foregroundStyle(.blue)
                    .font(.body)
                    .fontWeight(.black)

                case .error:
                    LoadingErrorView(
                        retryAction: {
                            viewModel.handleViewAction(.loadMoreImages)
                        }
                    )
                }
            } else {
                imagesListView
            }
        }
        .onAppear {
            viewModel.handleViewAction(.loadMoreImages)
        }
    }

    private var imagesListView: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.state.images, id: \.id) { imageModel in
                    let imageAvgColor = Color(hex: imageModel.averageHexColor)

                    NavigationLink(
                        destination: {
                            ZStack {
                                imageAvgColor
                                    .ignoresSafeArea()

                                KFImage(imageModel.imageUrl)
                                    .placeholder {
                                        ProgressView()
                                            .tint(.black)
                                    }
                                    .resizable()
                                    .onFailureImage(UIImage(systemName: "questionmark.diamond"))
                                    .aspectRatio(imageModel.width / imageModel.height,
                                                 contentMode: .fit)
                                    .clipped()
                            }
                            .navigationBackButton(color: imageAvgColor.isBright ? Color.black : Color.white)
                        },
                        label: {
                            ImagePreviewCell(imageModel: imageModel)
                        }
                    )
                }
                .padding()

                if viewModel.state.canLoadMore {
                    lastRowView
                } else {
                    Text("You've downloaded all existing images")
                        .font(.subheadline)
                        .foregroundStyle(.gray)
                }
            }
        }
        .refreshable {
            viewModel.handleViewAction(.refreshImages)
        }
    }

    private var lastRowView: some View {
        ZStack(alignment: .center) {
            switch viewModel.state.loadingState {
            case .loading:
                ProgressView()
            case .idle:
                EmptyView()
            case .error:
                LoadingErrorView(
                    retryAction: {
                        viewModel.handleViewAction(.loadMoreImages)
                    }
                )
            }
        }
        .onAppear {
            viewModel.handleViewAction(.loadMoreImages)
        }
    }
}
