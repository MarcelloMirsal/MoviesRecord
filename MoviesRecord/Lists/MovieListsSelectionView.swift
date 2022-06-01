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
    @State private var canPresentCreateListView: Bool = false
    let movie: Movie
    
    var body: some View {
        NavigationView {
            List(movieLists) { movieList in
                Button {
                    selectedMovieList = movieList
                    handleMovieListSelection()
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Text(movieList.name)
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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("New List") {
                        canPresentCreateListView = true
                    }
                }
            }
            .sheet(isPresented: $canPresentCreateListView, onDismiss: nil) {
                CreateMovieListView()
                    .environment(\.managedObjectContext, viewContext)
            }
            .overlay {
                if movieLists.isEmpty {
                    VStack(alignment: .center, spacing: 8) {
                        Text("No Movies Lists")
                            .fontWeight(.bold)
                        Text("Lists lets you save movies in lists to keep track of them like Favorites, Watched and Family lists")
                    }
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                }
            }
        }
    }
    
    func handleMovieListSelection() {
        guard let selectedMovieList = selectedMovieList else {return}
        // check if the movie is already on the list
        guard let listItems = selectedMovieList.movieListItems?.map({$0 as? MovieListItem}).compactMap({$0}) else {return}
        guard listItems.contains(where: {$0.apiID == movie.id}) == false else {
            return
        }
        let movieListItemFactory = MovieListItemFactory(context: viewContext)
        movieListItemFactory.createMovieListItem(apiID: movie.id, title: movie.originalTitle, posterPath: movie.posterPath, date: DateFormatter.date(fromSharedFormattedStringDate: movie.releaseDate), movieList: selectedMovieList)
    }
}

struct MovieListsSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        MovieListsSelectionView(movie: .mockedMovie)
            .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
    }
}
