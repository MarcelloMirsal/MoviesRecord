//
//  DiscoverMoviesViewModelTests.swift
//  MoviesRecordTests
//
//  Created by Mohammed Mirsal on 12/04/2022.
//

import XCTest
@testable import MoviesRecord

class DiscoverMoviesViewModelTests: XCTestCase {
    
    var sut: DiscoverMoviesViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = .init()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestFeed_ShouldReturnNotEmptyMovies() async {
        sut = .init(movieDBService: MockTheMovieDBService(responseData: self.discoverMoviesResponseData))
        
        await sut.requestFeed()
        
        XCTAssertFalse(sut.feedResponse.movies.isEmpty)
    }
    
    func testRequestFeedWhenAnErrorOccurred_ErrorMessageShouldBeNotNil() async {
        let badResponseData = "".data(using: .utf8)!
        sut = .init(movieDBService: MockTheMovieDBService(responseData: badResponseData))
        
        await sut.requestFeed()
        
        XCTAssertNotNil(sut.errorMessage)
    }
    
    /// this test is only validate that requesting next page is only allowed when the current page is not  the last page in the feed pagination,
    func testRequestFeedNextPage_FeedResponseShouldLoadTheNewPage() async {
        let newPage = 2
        sut = .init(movieDBService: MockTheMovieDBService(responseData: discoverMoviesResponseData))
        await sut.requestFeed() // set the initial feed response
        
        await sut.requestFeedNextPage()
        
        /// this because both two calls above will return the same mock data(discoverMoviesResponseData)
        XCTAssertEqual(sut.feedResponse.page+1, newPage)
    }
}


// MARK: Mocked Responses
extension DiscoverMoviesViewModelTests {
    var discoverMoviesResponseData: Data {
"""
{
    "page": 1,
    "results": [
        {
            "adult": false,
            "backdrop_path": "/egoyMDLqCxzjnSrWOz50uLlJWmD.jpg",
            "genre_ids": [
                28,
                878,
                35,
                10751
            ],
            "id": 675353,
            "original_language": "en",
            "original_title": "Sonic the Hedgehog 2",
            "overview": "After settling in Green Hills, Sonic is eager to prove he has what it takes to be a true hero. His test comes when Dr. Robotnik returns, this time with a new partner, Knuckles, in search for an emerald that has the power to destroy civilizations. Sonic teams up with his own sidekick, Tails, and together they embark on a globe-trotting journey to find the emerald before it falls into the wrong hands.",
            "popularity": 7221.466,
            "poster_path": "/8E7mIpEpSATxX5JEuw55GYx9hfk.jpg",
            "release_date": "2022-03-30",
            "title": "Sonic the Hedgehog 2",
            "video": false,
            "vote_average": 7.7,
            "vote_count": 335
        },
        {
            "adult": false,
            "backdrop_path": "/cugmVwK0N4aAcLibelKN5jWDXSx.jpg",
            "genre_ids": [
                16,
                28,
                14,
                12
            ],
            "id": 768744,
            "original_language": "ja",
            "original_title": "僕のヒーローアカデミア THE MOVIE ワールド ヒーローズ ミッション",
            "overview": "A mysterious group called Humarize strongly believes in the Quirk Singularity Doomsday theory which states that when quirks get mixed further in with future generations, that power will bring forth the end of humanity. In order to save everyone, the Pro-Heroes around the world ask UA Academy heroes-in-training to assist them and form a world-classic selected hero team. It is up to the heroes to save the world and the future of heroes in what is the most dangerous crisis to take place yet in My Hero Academia.",
            "popularity": 1295.008,
            "poster_path": "/4NUzcKtYPKkfTwKsLjwNt8nRIXV.jpg",
            "release_date": "2021-08-06",
            "title": "My Hero Academia: World Heroes' Mission",
            "video": false,
            "vote_average": 7.3,
            "vote_count": 136
        }
    ],
    "total_pages": 2,
    "total_results": 4
}
""".data(using: .utf8)!
    }
}
