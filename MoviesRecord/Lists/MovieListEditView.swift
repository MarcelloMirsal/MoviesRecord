//
//  MovieListEditView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 31/05/2022.
//

import SwiftUI

struct MovieListEditView: View {
    @StateObject private var viewModel: ListsViewModel = .init()
    @Environment(\.presentationMode) var presentationMode
    let movieListToEdit: MovieList
    @State private var movieListName: String
    init(movieListToEdit: MovieList) {
        self.movieListToEdit = movieListToEdit
        self._movieListName = .init(initialValue: movieListToEdit.name)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("List name", text: $movieListName)
                    .submitLabel(SubmitLabel.done)
                    .onSubmit {
                        saveListChanges()
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                saveListChanges()
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
            .onChange(of: movieListToEdit, perform: { newValue in
                movieListName = "QQQQ"
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit \(movieListToEdit.name)")
        }
    }

    func saveListChanges() {
        guard movieListName.isValidAsInput() else {return}
        viewModel.edit(movieListToEdit, editedName: movieListName)
        presentationMode.wrappedValue.dismiss()
    }
}

