//
//  TheMovieDBServiceRouterTests.swift
//  TheMovieDBServiceTests
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import XCTest
@testable import TheMovieDBService

class TheMovieDBServiceRouterTests: XCTestCase {
    
    var sut: TheMovieDBServiceRouter!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = .init()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testBaseURL_ShouldBeEqualToIdealBaseURL() {
        let idealBaseURL = URL(string: "https://api.themoviedb.org/3")!
        
        XCTAssertEqual(sut.baseURL, idealBaseURL)
    }
    
    func testDiscoverMoviesRequest_ShouldBeEqualToIdealURL() {
        let idealURL = URL(string: "https://api.themoviedb.org/3/discover/movie?api_key=\(NetworkingConstants.apiKey.rawValue)&page=1")!
        
        XCTAssertEqual(sut.discoverMoviesRequest().url, idealURL)
    }
}
