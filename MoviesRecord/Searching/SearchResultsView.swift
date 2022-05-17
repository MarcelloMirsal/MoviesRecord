//
//  SearchResultsView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 16/05/2022.
//

import SwiftUI
import Kingfisher

struct SearchResultsView: View {
    @StateObject var viewModel: SearchingViewModel
    let searchingText: String
    
    init(viewModel: SearchingViewModel = .init(), searchingText: String) {
        self._viewModel = .init(wrappedValue: viewModel)
        self.searchingText = searchingText
    }
    
    var body: some View {
        GeometryReader { proxy in
            List(viewModel.movies, id: \.id) { movie in
                NavigationLink {
                    MovieDetailsView(movie: movie)
                } label: {
                    HStack(alignment: .center, spacing: 8) {
                        KFImage(viewModel.imageURL(imagePath: movie.posterPath)?.url)
                            .placeholder({
                                Image(systemName: "film")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: proxy.size.width * 0.3, height: proxy.size.width * 0.3)
                                    .foregroundColor(.secondary)
                            })
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: proxy.size.width * 0.3, height: proxy.size.width * 0.3)
                            .cornerRadius(8)
                        VStack(alignment: .leading, spacing: 8) {
                            Text(movie.originalTitle)
                                .font(.headline)
                                .lineLimit(2)
                            Text(DateFormatter.sharedFormattedDate(stringDate: movie.releaseDate))
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical)
                    .shadow(radius: 12)
                }

            }
            .listStyle(.plain)
        }
        .overlay(content: {
            if viewModel.isInitialFeedLoading {
                TaskProgressView()
                    .padding()
            }
            else if viewModel.isInitialFeedFailedToLoad {
                TryAgainFeedButton(descriptionMessage: viewModel.errorMessage) {
                    Task {
                        await viewModel.searchForMovie(query: searchingText)
                    }
                }
                .padding()
            }
        })
        .dynamicTypeSize(..<DynamicTypeSize.accessibility4)
        .task {
            await viewModel.searchForMovie(query: searchingText)
        }
    }
}

struct SearchResultsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchResultsView(viewModel: MockSearchingViewModel(), searchingText: "Query")
    }
}
