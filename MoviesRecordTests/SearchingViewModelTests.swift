//
//  SearchingViewModelTests.swift
//  MoviesRecordTests
//
//  Created by Mohammed Mirsal on 11/05/2022.
//

import XCTest
@testable import MoviesRecord

class SearchingViewModelTests: XCTestCase {
    var sut: SearchingViewModel!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearchForMovie_FeedMoviesShouldBeNotEmpty() async {
        let searchQuery = "MOVIE NAME"
        sut = .init(movieDBService: MockTheMovieDBService(responseData: movieSearchingResponseData) )
        
        await sut.searchForMovie(query: searchQuery)
        
        XCTAssertFalse(sut.movies.isEmpty)
    }
}


// MARK: Mocked Responses
extension SearchingViewModelTests {
    var movieSearchingResponseData: Data {
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
