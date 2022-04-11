//
//  NetworkingManagerTests.swift
//  TheMovieDBServiceTests
//
//  Created by Mohammed Mirsal on 11/04/2022.
//

import XCTest
@testable import TheMovieDBService
import Alamofire

class NetworkingManagerTests: XCTestCase {
    
    var sut: NetworkingManager!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sut = .init()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    // MARK: Testing Network requests
    
    func testJSONRequest_ShouldReturnNotNilData() async {
        let networkRequest = URLRequest(url: .init(string: "google.com")!)
        arrangeSutWithMockedURLProtocolForSuccessfulDataResponse()
        
        let data = try? await sut.json(for: networkRequest)
        
        XCTAssertNotNil(data)
    }
    
    func testJSONRequestWithInvalidResponseCode_ShouldReturnNotNilError() async {
        let networkRequest = URLRequest(url: .init(string: "google.com")!)
        arrangeSutWithMockedURLProtocolForInvalidDataResponse()
        
        do {
            let _ = try await sut.json(for: networkRequest)
            XCTFail("This do block should fail; the request should throw an error")
        } catch {
            let responseError = error as? NetworkError
            XCTAssertNotNil(responseError)
        }
    }
}


// MARK: SUT arranges
fileprivate extension NetworkingManagerTests {
    var mockedSessionConfigs: URLSessionConfiguration {
        let mockedSessionConfigs = URLSessionConfiguration.ephemeral
        mockedSessionConfigs.protocolClasses = [MockURLProtocol.self]
        return mockedSessionConfigs
    }
    
    func arrangeSutWithMockedURLProtocolForSuccessfulDataResponse() {
        MockURLProtocol.requestHandler = { request in
            return (.init(), "{ responseMessage: true }".data(using: .utf8)! )
        }
        sut = .init(sessionConfigs: mockedSessionConfigs)
    }
    
    func arrangeSutWithMockedURLProtocolForInvalidDataResponse() {
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(url: request.url!, statusCode: 404, httpVersion: nil, headerFields: nil)!
            let data = "{key : value}".data(using: .utf8)!
            return (response, data)
        }
        sut = .init(sessionConfigs: mockedSessionConfigs)
    }
}
