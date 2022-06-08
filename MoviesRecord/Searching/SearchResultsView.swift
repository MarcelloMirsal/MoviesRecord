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
                    MovieListCell(movieTitle: movie.originalTitle, imageURL: viewModel.imageURL(imagePath: movie.posterPath)?.url, releaseData: DateFormatter.sharedFormattedDate(stringDate: movie.releaseDate), proxySize: proxy.size)
                }
            }
            .listStyle(.plain)
            .overlay( content: {
                if viewModel.movies.isEmpty && !viewModel.isInitialFeedLoading && !viewModel.isInitialFeedFailedToLoad {
                    Text("No results for '\(searchingText)' ")
                        .bold()
                        .foregroundColor(.secondary)
                }
            })
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
