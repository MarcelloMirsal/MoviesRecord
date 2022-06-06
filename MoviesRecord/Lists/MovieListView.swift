//
//  MovieListView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 28/05/2022.
//

import SwiftUI
import TheMovieDBService

struct MovieListView: View {
    @EnvironmentObject var movieList: MovieList
    @State private var selectedListItem: MovieListItem?
    let viewContext = CoreDataStack.shared.viewContext
    
    var listItems: [MovieListItem] {
        return movieList.listItems
    }
    let movieDBRouter = TheMovieDBServiceRouter()
    
    var body: some View {
        GeometryReader { proxy in
            List(listItems) { listItem in
                NavigationLink(tag: listItem, selection: $selectedListItem) {
                    MovieDetailsView(prototypeMovie: getPrototypeMovie(from: listItem))
                } label: {
                    MovieListCell(movieTitle: listItem.movieTitle, imageURL: movieDBRouter.imageRequest(forImageId: listItem.posterPath ?? "").url, releaseData: listItem.formattedStringDate, proxySize: proxy.size)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewContext.delete(listItem)
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                }
            }
            .navigationTitle(movieList.listName)
            .listStyle(.plain)
        }
    }
    
    func getPrototypeMovie(from movieListItem: MovieListItem) -> Movie {
        let releaseDate = movieListItem.formattedStringDate
        return .init(genreIDS: [], id: Int(movieListItem.apiID), originalTitle: movieListItem.movieTitle, overview: "", posterPath: movieListItem.posterPath, releaseDate: releaseDate, voteAverage: 0)
    }
}



struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
