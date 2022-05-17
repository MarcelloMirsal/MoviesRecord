//
//  TheMovieDBServiceTests.swift
//  TheMovieDBServiceTests
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import XCTest
@testable import TheMovieDBService

class TheMovieDBServiceTests: XCTestCase {
    var sut: TheMovieDBService!
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = .init()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testRequestDiscoverMovies_ShouldReturnDecodableObject() async {
        arrangeSutWithMockedNetworkMangerForSuccessfulResponse()
        
        let result = await sut.requestDiscoverMovies(page: 1, decodingType: [String : String].self)
        
        switch result {
        case .success:
            break
        case .failure:
            XCTFail("this mocked request should return valid decodable object.")
        }
    }
    
    func testRequestMovieVideos_ShouldReturnDecodableObject() async {
        arrangeSutWithMockedNetworkMangerForSuccessfulResponse()
        let result = await sut.requestMovieVideos(movieID: "1234", decodingType: [String : String].self)
        
        switch result {
        case .success:
            break
        case .failure:
            XCTFail("this mocked request should return valid decodable object.")
        }
    }
    
    func testRequestMovieImages_ShouldReturnDecodableObject() async {
        arrangeSutWithMockedNetworkMangerForSuccessfulResponse()
        let result = await sut.requestMovieImages(movieID: "1234", decodingType: [String : String].self)
        
        switch result {
        case .success:
            break
        case .failure:
            XCTFail("this mocked request should return valid decodable object.")
        }
    }
    
    func testRequestMovieCasting_ShouldReturnDecodableObject() async {
        arrangeSutWithMockedNetworkMangerForSuccessfulResponse()
        let result = await sut.requestMovieCasting(movieID: "1234", decodingType: [String : String].self)
        
        switch result {
        case .success:
            break
        case .failure:
            XCTFail("this mocked request should return valid decodable object.")
        }
    }
    
    func testRequestMovieSearch_ShouldReturnDecodableObject() async {
        let searchQuery = "Movie Name"
        arrangeSutWithMockedNetworkMangerForSuccessfulResponse()
        
        let result = await sut.requestMovieSearch(query: searchQuery, decodingType: [String : String].self)
        
        switch result {
        case .success:
            break
        case .failure:
            XCTFail("this mocked request should return valid decodable object.")
        }
    }
}

// MARK: sut arranges
extension TheMovieDBServiceTests {
    func arrangeSutWithMockedNetworkMangerForSuccessfulResponse() {
        let jsonData = """
            {
            "title": "JSON_String"
            }
""".data(using: .utf8)!
        let mockNetworkingManager = MockNetworkingManager(data: jsonData)
        sut = .init(networkingManager: mockNetworkingManager)
    }
}
