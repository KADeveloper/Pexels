//
//  ImagePreviewCell.swift
//  PexelsFeed
//
//  Created by Aleksei Kudriashov on 4/20/24.
//

import SwiftUI
import Kingfisher

struct ImagePreviewCell: View {
    let imageModel: ImageModel

    var body: some View {
        VStack {
            KFImage(imageModel.imageUrl)
                .placeholder {
                    ProgressView()
                        .tint(.black)
                }
                .loadDiskFileSynchronously(false)
                .resizable()
                .onFailureImage(UIImage(systemName: "questionmark.diamond"))
                .aspectRatio(imageModel.width / imageModel.height,
                             contentMode: .fit)
                .clipped()

                Text(imageModel.author)
                    .foregroundStyle(.blue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .padding()
        }
        .background(Color.white)
        .contentShape(.rect)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .shadow(color: .black.opacity(0.5), radius: 12)
    }
}
