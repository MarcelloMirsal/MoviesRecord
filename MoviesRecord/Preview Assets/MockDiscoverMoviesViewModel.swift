//
//  MockDiscoverMoviesViewModel.swift
//  MoviesRecord
//
//  Created by Mohammed Mirsal on 14/04/2022.
//

import Foundation


final class MockDiscoverMoviesViewModel: DiscoverMoviesViewModel {
    let isFeedEmpty: Bool
    let mockedIsFeedLoadingData: Bool
    let mockedIsInitialFeedFailed: Bool
    
    init(isInitialFeedFailed: Bool = false, isFeedLoadingData: Bool = false, isFeedEmpty: Bool = false) {
        self.mockedIsInitialFeedFailed = isInitialFeedFailed
        self.mockedIsFeedLoadingData = isFeedLoadingData
        self.isFeedEmpty = isFeedEmpty
    }
    override var movies: [Movie] {
        return isFeedEmpty ? [] : [Self.demoMovie, Self.demoMovie2]
    }
    
    override var isFeedLoadingData: Bool {
        return mockedIsFeedLoadingData
    }
    
    override var isInitialFeedFailedToLoad: Bool {
        return mockedIsInitialFeedFailed
    }
    
    override func requestFeed() async {
        
    }
}


fileprivate extension MockDiscoverMoviesViewModel {
    static var demoMovie = Movie(genreIDS: [1,2], id: 1, originalTitle: "Birds of Prey", overview: "This is an overview", posterPath: "/h4VB6m0RwcicVEZvzftYZyKXs6K.jpg", releaseDate: "2020-10-10" , voteAverage: 7.0)
    
    static var demoMovie2 = Movie(genreIDS: [1,2], id: 2, originalTitle: "RED", overview: "This is an overview", posterPath: "/h4VB6m0RwcicVEZvzftYZyKXs6K.jpg", releaseDate: "2022-11-14" , voteAverage: 5.0)
}
