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
    @StateObject private var viewModel = ListsViewModel()
    @State private var selectedMovieList: MovieList?
    
    
    var body: some View {
        NavigationView {
            List(movieLists) { movieList in
                NavigationLink(tag: movieList, selection: $selectedMovieList) {
                    MovieListView().environmentObject(movieList)
                } label: {
                    HStack(spacing: 8) {
                        Text(movieList.name ?? "")
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
                        Image(systemName: "trash")
                    }
                }
            }
            .confirmationDialog("are you sure you want to delete List '\(movieListToDelete?.name ?? "")' ?", isPresented: $canShowConfirmationDialog,   titleVisibility: .visible, presenting: movieListToDelete, actions: { data in
                Button("Delete", role: .destructive) {
                    guard let movieListToDelete = movieListToDelete else {
                        return
                    }
                    viewModel.delete(movieListToDelete)
                }
            })
            .listStyle(.plain)
            .sheet(isPresented: $shouldPresentListCreationView, onDismiss: nil, content: {
                CreateMovieListView()
                    .environmentObject(viewModel)
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
    }
}



class ListsViewModel: ObservableObject {
    private let coreDataStack = CoreDataStack.shared
    
    func createNewMovieList(name: String) {
        guard canCreateMovieList(name: name) else {return}
        let movieListFactory = MovieListFactory(context: coreDataStack.viewContext)
        movieListFactory.createNewMovieList(name: name)
    }
    
    func delete(_ movieList: MovieList) {
        coreDataStack.viewContext.delete(movieList)
    }
    
    
    func canCreateMovieList(name: String) -> Bool {
        guard name.trimmingCharacters(in: .whitespaces).isEmpty else {return true}
        return false
    }
    
}


struct CreateMovieListView: View {
    @EnvironmentObject private var viewModel: ListsViewModel
    @Environment(\.presentationMode) var presentationMode
    @State private var movieListName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                List {
                    TextField("List name", text: $movieListName)
                        .submitLabel(SubmitLabel.done)
                        .onSubmit {
                            saveList()
                        }
                }
                .toolbar(content: {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            saveList()
                        }
                        .disabled(!viewModel.canCreateMovieList(name: movieListName))
                    }
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                })
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("New List")
        }
    }
    
    func saveList() {
        guard viewModel.canCreateMovieList(name: movieListName) else {return}
        viewModel.createNewMovieList(name: movieListName)
        presentationMode.wrappedValue.dismiss()
    }
}

import CoreData

class CoreDataStack {
    private let persistentContainer = NSPersistentContainer(name: "MoviesRecordPersistentModel")
    
    static var shared: CoreDataStack = .init()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    private init() {
        persistentContainer.loadPersistentStores { [weak self] store, error in
            self?.persistentContainer.viewContext.mergePolicy = NSMergePolicy.mergeByPropertyObjectTrump
        }
    }
    func saveContext() {
        guard viewContext.hasChanges else {return}
        do {
            try viewContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}


struct MovieListFactory {
    let movieListEntity = MovieList.entity()
    let context: NSManagedObjectContext
    
    @discardableResult
    func createNewMovieList(name: String) -> MovieList {
        let newMovieList = MovieList(entity: movieListEntity, insertInto: context)
        newMovieList.name = name
        newMovieList.createDate = .init()
        return newMovieList
    }
    
    
}
