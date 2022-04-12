//
//  NetworkingConstantTests.swift
//  TheMovieDBServiceTests
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import XCTest
@testable import TheMovieDBService

class NetworkingConstantTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testApiKey_ShouldReturnApiKeyEqualToIdeal() {
        let idealApiKey = "6203d05815ada391f8b581d00ebbdbd5"
        
        XCTAssertEqual(idealApiKey, NetworkingConstants.apiKey.rawValue)
    }

}








