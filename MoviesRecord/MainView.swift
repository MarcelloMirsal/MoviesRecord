//
//  MainView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 12/04/2022.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            DiscoverMoviesView()
            SearchView()
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
