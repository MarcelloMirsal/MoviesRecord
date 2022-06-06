//
//  ExtraInfoView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 06/06/2022.
//


import SwiftUI

struct ExtraInfoView: View {

    @AppStorage(CoreDataStack.cloudKitToggleStorageKey, store: .standard) private var iCloudSyncToggled = true
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Toggle("iCloud Sync", isOn: $iCloudSyncToggled)
                        .onChange(of: iCloudSyncToggled) { newValue in
                            CoreDataStack.shared.saveContext()
                            CoreDataStack.shared.setupContainer(withSync: newValue)
                        }
                } header: {
                    Text("Sync")
                } footer: {
                    Text("Sync Lists with your devices.")
                }
            }
            .navigationTitle("Extra")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem {
            Label("Extra", systemImage: "ellipsis")
        }
    }
}

struct ExtraInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ExtraInfoView()
    }
}
