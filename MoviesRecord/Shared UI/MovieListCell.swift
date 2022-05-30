//
//  MovieListCell.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 28/05/2022.
//

import SwiftUI
import Kingfisher

struct MovieListCell: View {
    let movieTitle: String
    let imageURL: URL?
    let releaseData: String
    let proxySize: CGSize
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            KFImage(imageURL)
                .placeholder({
                    Image(systemName: "film")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: proxySize.width * 0.3, height: proxySize.width * 0.3)
                        .foregroundColor(.secondary)
                })
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: proxySize.width * 0.3, height: proxySize.width * 0.3)
                .shadow(color: Color("Shadow") ,radius: 12)
            VStack(alignment: .leading, spacing: 8) {
                Text(movieTitle)
                    .font(.headline)
                    .lineLimit(2)
                Text(releaseData)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical)
    }
}

struct MovieListCell_Previews: PreviewProvider {
    static var previews: some View {
        MovieListCell(movieTitle: "the Movie", imageURL: nil, releaseData: "19 Apr 2020", proxySize: UIScreen.main.bounds.size)
    }
}
