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
    @State var movieListNameText: String
    private let movieListOriginalName: String
    init(movieListToEdit: MovieList) {
        self.movieListToEdit = movieListToEdit
        self.movieListOriginalName = movieListToEdit.name
        self._movieListNameText = .init(initialValue: movieListToEdit.name)
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("List name", text: $movieListNameText)
                    .submitLabel(SubmitLabel.done)
                    .onSubmit {
                        saveListChanges()
                    }
                    .toolbar(content: {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button("Save") {
                                saveListChanges()
                            }
                            .disabled(!movieListNameText.isValidAsInput())
                        }
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Cancel") {
                                presentationMode.wrappedValue.dismiss()
                            }
                        }
                    })
            }
            .onChange(of: movieListToEdit, perform: { newValue in
                movieListNameText = "QQQQ"
            })
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Edit \(movieListOriginalName)")
        }
    }

    func saveListChanges() {
        guard movieListNameText.isValidAsInput() else {return}
        viewModel.edit(movieListToEdit, editedName: movieListNameText)
        presentationMode.wrappedValue.dismiss()
    }
}

