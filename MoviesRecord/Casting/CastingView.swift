//
//  CastingView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 08/05/2022.
//

import SwiftUI
import Kingfisher

struct CastingView: View {
    @StateObject var viewModel: CastingViewModel
    init(movieID: Int) {
        self._viewModel = .init(wrappedValue: .init(movieID: movieID))
    }
    /// init for Preview and mocking
    fileprivate init() {
        self._viewModel = .init(wrappedValue: MockCastingViewModel(movieID: 0) )
    }
    var body: some View {
        let columns: [GridItem] = Array(repeating: GridItem(.adaptive(minimum: 150), spacing: 10, alignment: .top), count: 2)
        ScrollView {
            LazyVGrid(columns: columns , spacing: 10) {
                ForEach(viewModel.movieCasts, id: \.id) { movieCast in
                    CastingCellView(name: movieCast.originalName, character: movieCast.character, imageURL: viewModel.castImageRequest(movieCast: movieCast))
                }
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 32)
        }
        .background(Color(uiColor: .systemGray5))
        .navigationBarTitle("Casting")
        .navigationBarTitleDisplayMode(.inline)
        .overlay(content: {
            if viewModel.isInitialFeedLoading {
                TaskProgressView()
            }
            else if viewModel.isInitialFeedFailedToLoad {
                TryAgainFeedButton(descriptionMessage: viewModel.errorMessage) {
                    Task { await viewModel.requestCasting()}
                }
                .padding()
            }
        })
    }
}

struct CastingView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLink(isActive: .constant(true)) {
                CastingView()
            } label: {
                Text("Hello Casting")
            }
        }
    }
}

fileprivate struct CastingCellView: View {
    let name: String
    let character: String?
    let imageURL: URLRequest?
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            KFImage(imageURL?.url)
                .placeholder({
                    Image("CastImage")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .hidden()
                        .overlay {
                            Color(uiColor: .lightGray)
                        }
                })
                .resizable()
                .cancelOnDisappear(true)
                .retry(maxCount: 5, interval: .seconds(2))
                .scaledToFit()
            VStack(spacing: 4) {
                Text(name.capitalized)
                    .fontWeight(.bold)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.leading)
                Text(character?.capitalized ?? "")
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
                    
            }
            .lineLimit(1)
            .padding(8)
        }
        .background(Color(uiColor: .systemGray6) )
        .cornerRadius(8)
    }
}



