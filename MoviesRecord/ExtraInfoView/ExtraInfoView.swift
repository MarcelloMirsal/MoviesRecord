//
//  ExtraInfoView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 06/06/2022.
//


import SwiftUI
import Kingfisher

struct ExtraInfoView: View {
    @AppStorage(CoreDataStack.cloudKitToggleStorageKey, store: .standard) private var iCloudSyncToggled = true
    @State private var isClearCacheDisabled = false
    @State private var showCacheClearingMessage = false
    @State private var cacheSize: String = ""
    @State private var canPresentCacheDeletionConfirmation = false
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(role: .destructive) {
                        canPresentCacheDeletionConfirmation = true
                    } label: {
                        HStack {
                            Text("Clear cache")
                            Spacer()
                            Text(cacheSize)
                        }
                    }
                    .disabled(isClearCacheDisabled)
                    .confirmationDialog("", isPresented: $canPresentCacheDeletionConfirmation) {
                        Button("Clear Cached Images", role: .destructive) {
                            isClearCacheDisabled = true
                            ImageCache.default.clearDiskCache {
                                isClearCacheDisabled = false
                                showCacheClearingMessage = true
                                calculateCacheSize()
                            }
                        }
                    }
                } header: {
                    Text("Storage")
                } footer: {
                    Text("MoviesRecord is caching images after been downloaded to avoid re-downloading them when required, Clear cache will delete all images in the cache.")
                }
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
                
                Section("about") {
                    Link("Privacy Policy", destination: .init(string: "https://sites.google.com/view/moviesrecord/privacy-policy")!)
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("1.0")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Extra")
            .navigationBarTitleDisplayMode(.inline)
        }
        .task {
            calculateCacheSize()
        }
        .tabItem {
            Label("Extra", systemImage: "ellipsis")
        }
    }
    
    func calculateCacheSize() {
        ImageCache.default.calculateDiskStorageSize { result in
            if case .success(let size) = result {
                guard size > 0 else {
                    isClearCacheDisabled = true
                    cacheSize = "0.0 MB"
                    return
                }
                let megabyteFactor = pow(1024.0, 2.0)
                let sizeInMegabytes = Double(size) / megabyteFactor
                cacheSize = String(format: "%.2fMB", sizeInMegabytes)
                isClearCacheDisabled = false
            }
        }
    }
}

struct ExtraInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ExtraInfoView()
    }
}

