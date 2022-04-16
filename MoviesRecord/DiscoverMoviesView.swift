//
//  DiscoverMoviesView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 12/04/2022.
//

import SwiftUI
import Kingfisher

struct DiscoverMoviesView: View {
    @StateObject var viewModel: DiscoverMoviesViewModel
    init(viewModel: DiscoverMoviesViewModel = .init()) {
        self._viewModel = .init(wrappedValue: viewModel)
    }
    let gridItem = GridItem.init(.adaptive(minimum: 250), spacing: 16)
    
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: [gridItem], spacing: 16) {
                    Section {
                        ForEach(viewModel.movies, id: \.id) { movie in
                            MovieView(title: movie.originalTitle, releaseDate: viewModel.posterDate(stringDate: movie.releaseDate), imageURL: viewModel.imageURL(forImageID: movie.posterPath))
                        }
                    } header: {
                        HStack {
                            Text(viewModel.headerDate())
                                .font(.title2)
                                .fontWeight(.bold)
                            Spacer()
                        }
                    } footer: {
                        if viewModel.canShowNextPageLoadingProgress {
                            TaskProgressView()
                                .onAppear {
                                    Task {
                                        await viewModel.requestFeedNextPage()}
                                }
                        }
                        else if viewModel.canShowNextPageLoadingError {
                            TryAgainFeedButton(descriptionMessage: viewModel.errorMessage) {
                                Task {
                                    await viewModel.requestFeedNextPage()
                                }
                            }
                            .padding()
                        }
                    }

                }
                .padding()
            }
            .overlay(content: {
                if viewModel.isInitialFeedLoading {
                    TaskProgressView()
                }
                else if viewModel.isInitialFeedFailedToLoad {
                    TryAgainFeedButton(descriptionMessage: viewModel.errorMessage) {
                        Task { await viewModel.requestFeed()}
                    }
                    .padding()
                }
            })
            .navigationTitle("Discover")
        }
        
    }
}


fileprivate struct MovieView: View {
    let title: String
    let releaseDate: String
    let imageURL: URLRequest?
    
    var body: some View {
        ZStack(alignment: .top) {
            KFImage(imageURL?.url)
                .placeholder({
                    Color(uiColor: .lightGray)
                        .frame(minWidth: 200, minHeight: 300)
                        .overlay {
                            Image(systemName: "film")
                                .resizable()
                                .scaledToFit()
                                .font(.body)
                                .padding()
                        }
                })
                .resizable()
                .cancelOnDisappear(true)
                .retry(maxCount: 5, interval: .seconds(2))
                .scaledToFit()
                .overlay {
                    LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .center)
                }
            HStack {
                VStack(alignment: .leading,spacing: 6) {
                    Text(releaseDate)
                        .font(.headline)
                        .foregroundColor(.gray)
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .lineLimit(2)
                        .foregroundColor(.white)
                }
                .padding()
                Spacer()
            }
        }
        .cornerRadius(10)
    }
}

struct DiscoverMoviesView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DiscoverMoviesView(viewModel: MockDiscoverMoviesViewModel())
            DiscoverMoviesView(viewModel: MockDiscoverMoviesViewModel(isInitialFeedFailed: true, isFeedEmpty: true))
            DiscoverMoviesView(viewModel: MockDiscoverMoviesViewModel( isFeedLoadingData: true, isFeedEmpty: true))
        }
    }
}

