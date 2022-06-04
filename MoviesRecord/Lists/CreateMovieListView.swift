//
//  CreateMovieListView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import SwiftUI

struct CreateMovieListView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var movieListName: String = ""
    
    var body: some View {
        NavigationView {
            Form {
                TextField("List name", text: $movieListName)
                    .submitLabel(SubmitLabel.done)
                    .onSubmit {
                        saveList()
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Done") {
                                saveList()
                            }
                            .disabled(!movieListName.isValidAsInput())
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
        guard movieListName.isValidAsInput() else {return}
        let movieListFactory = MovieListFactory(context: CoreDataStack.shared.viewContext)
        movieListFactory.createNewMovieList(name: movieListName)
        presentationMode.wrappedValue.dismiss()
    }
}
