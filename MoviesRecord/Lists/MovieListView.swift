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
    @Environment(\.managedObjectContext) var viewContext
    
    @State private var selectedListItem: MovieListItem?
    var listItems: [MovieListItem] {
        return movieList.movieListItems?.array.map({$0 as? MovieListItem}).compactMap({$0}) ?? []
    }
    let movieDBRouter = TheMovieDBServiceRouter()
    
    
    
    var body: some View {
        GeometryReader { proxy in
            List(listItems) { listItem in
                NavigationLink(tag: listItem, selection: $selectedListItem) {
                    MovieDetailsView(movie: .mockedMovie)
                } label: {
                    MovieListCell(movieTitle: listItem.title ?? "", imageURL: movieDBRouter.imageRequest(forImageId: listItem.posterPath ?? "").url, releaseData: DateFormatter.stringDate(fromSharedFormattedDate: listItem.date ?? .init()), proxySize: proxy.size)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        viewContext.delete(listItem)
                    } label: {
                        Image(systemName: "trash.fill")
                    }
                }
            }
            .navigationTitle(movieList.name ?? "")
            .listStyle(.plain)
        }
    }
}

struct MovieListView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListView()
    }
}
