//
//  ListsView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 26/05/2022.
//

import SwiftUI

struct ListsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \MovieList.createDate, ascending: false)],
        animation: .default) private var movieLists: FetchedResults<MovieList>
    
    @State private var shouldPresentListCreationView = false
    @State private var canShowConfirmationDialog = false
    @State private var movieListToDelete: MovieList? = nil
    @State private var movieListToEdit: MovieList? = nil
    @State private var selectedMovieList: MovieList?
    @StateObject private var viewModel = ListsViewModel()
    
    
    var body: some View {
        NavigationView {
            List(movieLists) { movieList in
                NavigationLink(tag: movieList, selection: $selectedMovieList) {
                    MovieListView().environmentObject(movieList)
                } label: {
                    HStack(spacing: 8) {
                        Text(movieList.name)
                            .fontWeight(.bold)
                        Spacer()
                        Text(movieList.movieListItems?.count.description ?? "")
                            .foregroundColor(.secondary)
                    }
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                    Button(role: .destructive) {
                        movieListToDelete = movieList
                        canShowConfirmationDialog = true
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    
                    Button {
                        movieListToEdit = movieList
                    } label: {
                        Label("Edit", systemImage: "square.and.pencil")
                    }
                    .tint(.blue)
                    .controlSize(ControlSize.large)
                    
                }
            }
            .sheet(isPresented: $shouldPresentListCreationView, content: {
                CreateMovieListView()
                    .environment(\.managedObjectContext, viewContext)
            })
            .sheet(item: $movieListToEdit, content: { movieListToEdit in
                MovieListEditView(movieListToEdit: movieListToEdit)
                    .environment(\.managedObjectContext, viewContext)
            })
            .confirmationDialog("are you sure you want to delete List '\(movieListToDelete?.name ?? "")' ?", isPresented: $canShowConfirmationDialog, titleVisibility: .visible, presenting: movieListToDelete, actions: { data in
                Button("Delete", role: .destructive) {
                    guard let movieListToDelete = movieListToDelete else { return }
                    viewModel.delete(movieListToDelete)
                }
            })
            .listStyle(.plain)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        shouldPresentListCreationView = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            })
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
            .navigationTitle("Lists")
        }
        .tabItem {
            Label("Lists", systemImage: "list.triangle")
        }
        .dynamicTypeSize(..<DynamicTypeSize.accessibility2)
    }
}

struct ListsView_Previews: PreviewProvider {
    static var previews: some View {
        ListsView()
            .environment(\.managedObjectContext, CoreDataStack.shared.viewContext)
    }
}
