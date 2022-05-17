//
//  SearchView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 10/05/2022.
//

import SwiftUI

struct SearchView: View {
    @State private var searchingText: String = ""
    @State private var canShowSearchResults = false
    @State var shouldClearRecentSearchQueries = false
    @StateObject private var viewModel = SearchViewModel()
    @AppStorage("RecentSearchQueries", store: .standard) var recentSearchQueries: String = ""

    
    var body: some View {
        NavigationView {
            VStack {
                LastSearchingView(searchingText: $searchingText, canShowSearchResults: $canShowSearchResults, shouldClearRecentSearchQueries: $shouldClearRecentSearchQueries, lastQueries: viewModel.formattedSearchQueriesArray(from: recentSearchQueries))
                    .searchable(text: $searchingText, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search for movies"))
                    .onSubmit(of: .search, {
                        canShowSearchResults = !searchingText.isEmpty
                        withAnimation(.easeOut(duration: 1)) {
                            recentSearchQueries = viewModel.insert(searchQuery: searchingText, currentSearchQueries: recentSearchQueries)
                        }
                    })
                    .navigationTitle("Search")
                    .navigationBarTitleDisplayMode(.inline)
                NavigationLink(isActive: $canShowSearchResults) {
                    SearchResultsView(searchingText: searchingText)
                        .navigationTitle(searchingText)
                } label: {
                    EmptyView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onChange(of: shouldClearRecentSearchQueries, perform: { newValue in
            if newValue {
                recentSearchQueries = ""
            }
        })
        .dynamicTypeSize(..<DynamicTypeSize.accessibility4)
        .tabItem {
            Label("Search", systemImage: "magnifyingglass")
        }
    }
}

fileprivate struct LastSearchingView: View {
    @Binding var searchingText: String
    @Binding var canShowSearchResults: Bool
    @Binding var shouldClearRecentSearchQueries: Bool
    @ScaledMetric(relativeTo: .title3) var scale: CGFloat = 20
    let lastQueries: [String]
    
    var body: some View {
        List {
            Section {
                ForEach(lastQueries, id: \.self) { result in
                    HStack(alignment: .center) {
                        Button(result) {
                            searchingText = result
                            canShowSearchResults = true
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.body.weight(.light))
                            .foregroundColor(.gray)
                    }
                }
            } header: {
                HStack(alignment: .center) {
                    Text("Recent searches")
                        .font(.title3.bold())
                    .foregroundColor(.black)
                    Spacer()
                    Button {
                        shouldClearRecentSearchQueries = true
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: scale, height: scale)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 4)
            }
        }
        .listStyle(PlainListStyle())
        .dynamicTypeSize(..<DynamicTypeSize.accessibility4)
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}


fileprivate class SearchViewModel: ObservableObject {
    
    func formattedSearchQueriesArray(from searchQueries: String) -> [String] {
        guard !searchQueries.isEmpty else {return []}
        return searchQueries.components(separatedBy: ",")
    }
    
    func insert(searchQuery: String, currentSearchQueries: String) -> String {
        var formattedQueries = formattedSearchQueriesArray(from: currentSearchQueries)
        formattedQueries.insert(searchQuery, at: 0)
        let sizeRange = formattedQueries.count > 5 ? 0..<5 : 0..<formattedQueries.count
        return formattedQueries[sizeRange].joined(separator: ",")
    }
}
