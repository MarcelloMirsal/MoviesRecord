//
//  MovieListsSelectionView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 29/05/2022.
//

import SwiftUI

struct MovieListsSelectionView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MovieList.createDate, ascending: false)],
        animation: .default) private var movieLists: FetchedResults<MovieList>
    @Environment(\.presentationMode) var presentationMode
    @State private var selectedMovieList: MovieList?
    let movie: Movie
    
    var body: some View {
        NavigationView {
            List(movieLists) { movieList in
                Button {
                    selectedMovieList = movieList
                    handleMovieListSelection()
                } label: {
                    Text(movieList.name ?? "")
                }
                .foregroundColor(.primary)
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Add to list")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel", role: .cancel) {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
    
    func handleMovieListSelection() {
        guard let selectedMovieList = selectedMovieList else {return}
        guard let listItems = selectedMovieList.movieListItems?.map({$0 as? MovieListItem}).compactMap({$0}) else {return}
        guard listItems.contains(where: {$0.apiID == movie.id}) == false else {
            return
        }
        let movieListItemFactory = MovieListItemFactory()
        movieListItemFactory.createMovieListItem(apiID: movie.id, title: movie.originalTitle, posterPath: movie.posterPath, date: DateFormatter.date(fromSharedFormattedStringDate: movie.releaseDate), movieList: selectedMovieList)
    }
}

struct MovieListsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListsSelectionView(movie: .mockedMovie)
            .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
    }
}



import CoreData
struct MovieListItemFactory {
    
    let context: NSManagedObjectContext = CoreDataStack.shared.viewContext
    
    @discardableResult
    func createMovieListItem(apiID: Int, title: String, posterPath: String?, date: Date, movieList: MovieList) -> MovieListItem {
        let newMovieListItem = MovieListItem(entity: MovieListItem.entity(), insertInto: context)
        newMovieListItem.apiID = Int64(apiID)
        newMovieListItem.title = title
        newMovieListItem.date = date
        newMovieListItem.posterPath = posterPath
        newMovieListItem.movieList = movieList
        return newMovieListItem
    }
}
