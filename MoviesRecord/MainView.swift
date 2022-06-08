//
//  MainView.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 12/04/2022.
//

import SwiftUI

struct MainView: View {
    @AppStorage("IsFirstTimeLaunch", store: .standard) var isFirstTimeLaunch: Bool = true
    var body: some View {
        TabView {
            DiscoverMoviesView()
            ListsView()
            SearchView()
            ExtraInfoView()
        }        
        .sheet(isPresented: $isFirstTimeLaunch) {
            OnBoardingView()
                .interactiveDismissDisabled(true)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
