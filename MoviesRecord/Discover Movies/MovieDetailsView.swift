//
//  MovieDetailsView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 19/04/2022.
//

import SwiftUI
import Kingfisher

struct MovieDetailsView: View {
    @StateObject var viewModel: MovieDetailsViewModel
    init(movie: Movie) {
        _viewModel = .init(wrappedValue: MovieDetailsViewModel(movie: movie))
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                KFImage(viewModel.posterURL)
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
                    .aspectRatio(contentMode: .fit)
                    .cornerRadius(16)
                    .padding(.top, 32)
                    .padding(.horizontal, 24)
                    .shadow(radius: 40)
                Text(viewModel.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal, 16)
                Text(viewModel.genres)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 12)
                HStack {
                    ForEach(1...viewModel.numberOfStars, id: \.self) { count in
                        if 1...Int(viewModel.rating) ~= count {
                            Image(systemName: "star.fill" )
                                .foregroundColor(.yellow)
                        } else {
                            Image(systemName: "star" )
                                .foregroundColor(.gray)
                        }
                    }
                    .font(.title.weight(.thin))
                }
                .padding(.horizontal, 16)
                if viewModel.trailerVideoURL != nil {
                    HStack {
                        Spacer()
                        Button(action: {
                            guard let url = viewModel.trailerVideoURL else {return}
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }, label: {
                            Label("trailer", systemImage: "play.fill")
                        })
                            .font(.title3.bold())
                            .buttonStyle(.borderedProminent)
                            .padding()
                        Spacer()
                    }
                }
                Group {
                    Text("overview")
                        .textCase(.uppercase)
                        .font(.title2.bold())
                    Text(viewModel.overview)
                        .font(.body.weight(.semibold))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
                
                Group {
                    Text("release date")
                        .textCase(.uppercase)
                        .font(.title2.bold())
                    
                    Text(viewModel.releaseDate)
                        .font(.body.weight(.semibold))
                        .multilineTextAlignment(.leading)
                }
                .padding(.horizontal)
            }
            Group {
                HStack {
                    VStack(spacing: 24) {
                        NavigationLink("Images", destination:
                                        MovieImagesView(movieID: String(viewModel.movie.id))
                                        .navigationBarTitle("Images")
                        )
                        NavigationLink("Casting", destination: Color.red)
                    }
                    Spacer()
                }
            }
            .font(.title3.bold())
            .padding(12)
            .padding(.bottom, 32)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            NavigationLink(isActive: .constant(true)) {
                MovieDetailsView(movie: .mockedMovie)
            } label: {
                Color.gray
            }
        }
    }
}
