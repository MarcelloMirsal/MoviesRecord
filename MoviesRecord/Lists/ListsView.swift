//
//  ListsView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 26/05/2022.
//

import SwiftUI

struct ListsView: View {
    
    @State private var shouldPresentListCreationView = false
    @State private var canShowConfirmationDialog = false
    @State private var movieListToDelete: MovieList? = nil
    @State private var movieListToEdit: MovieList? = nil
    @State private var selectedMovieList: MovieList?
    @StateObject private var viewModel = ListsViewModel()
    
    
    var body: some View {
        NavigationView {
            List {
            ForEach(viewModel.movieLists) { movieList in
                NavigationLink(tag: movieList, selection: $selectedMovieList) {
                    MovieListView()
                        .environmentObject(movieList)
                } label: {
                    HStack(spacing: 8) {
                        Text(movieList.listName)
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
        }
        .sheet(isPresented: $shouldPresentListCreationView, content: {
            CreateMovieListView()
        })
        .sheet(item: $movieListToEdit, content: { movieListToEdit in
            MovieListEditView(movieListToEdit: movieListToEdit)
        })
        .confirmationDialog("'\(movieListToDelete?.name ?? "")' will be deleted from iCloud and all other devices too. This action cannot be undone.", isPresented: $canShowConfirmationDialog, titleVisibility: .visible, presenting: movieListToDelete, actions: { data in
            Button("Delete", role: .destructive) {
                guard let movieListToDelete = movieListToDelete else { return }
                viewModel.delete(movieListToDelete)
            }
        })
        .listStyle(.plain)
        .onDisappear(perform: {
            viewModel.shouldApplyUpdates = false
        })
        .onAppear(perform: {
            selectedMovieList = nil
            viewModel.shouldApplyUpdates = true
        })
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
            if viewModel.movieLists.isEmpty {
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
