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
    @Environment(\.verticalSizeClass) var verticalSizeClass
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var canShowImagePresentation: Bool = false
    @State private var canShowMovieListsSelectionView: Bool = false
    init(movie: Movie) {
        _viewModel = .init(wrappedValue: .init(movie: movie))
    }
    init(prototypeMovie: Movie) {
        _viewModel = .init(wrappedValue: .init(prototypeMovie: prototypeMovie))
    }
    
    var isPortrait: Bool {
        return horizontalSizeClass == .compact && verticalSizeClass == .regular
    }
    
    var body: some View {
        GeometryReader(content: { proxy in
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    if isPortrait {
                        KFImage(viewModel.posterURL)
                            .placeholder({
                                Image(systemName: "film")
                                    .resizable()
                                    .scaledToFit()
                                    .font(.body)
                                    .padding()
                                    .foregroundColor(Color(uiColor: .lightGray))
                            })
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .cornerRadius(16)
                            .padding(.top, 32)
                            .padding(.horizontal, 24)
                            .shadow(radius: 40)
                            .onTapGesture {
                                canShowImagePresentation = true
                            }
                            .fullScreenCover(isPresented: $canShowImagePresentation, onDismiss: nil) {
                                ImagePresentationView(imageURL: viewModel.posterURL)
                            }
                    }
                    else {
                        HStack(alignment: .center) {
                            VStack(alignment: .leading, spacing: 10) {
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
                            }
                            Spacer()
                            KFImage(viewModel.posterURL)
                                .placeholder {
                                    Image(systemName: "film")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: proxy.size.width / 2, height: proxy.size.width / 3)
                                        .foregroundColor(Color(uiColor: .lightGray))
                                }
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: proxy.size.height * 0.65 , height: proxy.size.height * 0.9)
                                .cornerRadius(16)
                                .padding(.top, 32)
                                .padding(.horizontal, 12)
                                .shadow(radius: 40)
                                .onTapGesture {
                                    canShowImagePresentation = true
                                }
                                .fullScreenCover(isPresented: $canShowImagePresentation, onDismiss: nil) {
                                    ImagePresentationView(imageURL: viewModel.posterURL)
                                }
                            
                        }
                    }
                    if isPortrait {
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
                                    Image(systemName: "star.fill")
                                        .foregroundColor(.yellow)
                                } else {
                                    Image(systemName: "star")
                                        .foregroundColor(.gray)
                                }
                            }
                            .font(.title.weight(.thin))
                        }
                        .padding(.horizontal, 16)
                    }
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
                            NavigationLink("Casting", destination: CastingView(movieID: viewModel.movie.id))
                        }
                        Spacer()
                    }
                }
                .font(.title3.bold())
                .padding(12)
                .padding(.bottom, 32)
            }
            .dynamicTypeSize(..<DynamicTypeSize.accessibility4)
        })
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        canShowMovieListsSelectionView = true
                    } label: {
                        Image(systemName: "list.triangle")
                    }
                }
            })
            .sheet(isPresented: $canShowMovieListsSelectionView, onDismiss: nil, content: {
                MovieListsSelectionView(movie: viewModel.movie)
                    .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
            })
            .background(Color(uiColor: .systemGray.withAlphaComponent(0.1)))
            .navigationBarTitle("Movie details")
            .navigationBarTitleDisplayMode(.inline)
            .overlay( content: {
                if viewModel.isLoadingMovieDetails {
                    TaskProgressView()
                }
            })
            .disabled(viewModel.isLoadingMovieDetails)
    }
}

struct MovieDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            NavigationView {
                NavigationLink(isActive: .constant(true)) {
                    MovieDetailsView(movie: .mockedMovie)
                } label: {
                    Color.gray
                }
            }
            NavigationView {
                NavigationLink(isActive: .constant(true)) {
                    MovieDetailsView(movie: .mockedMovie)
                } label: {
                    Color.gray
                }
            }
            .previewInterfaceOrientation(.landscapeLeft)
            NavigationView {
                NavigationLink(isActive: .constant(true)) {
                    MovieDetailsView(movie: .mockedMovie)
                } label: {
                    Color.gray
                }
            }
            .previewInterfaceOrientation(.landscapeRight)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
