//
//  NetworkAPI.swift
//  SystemTestTests
//
//  Created by Ramesh Maddali on 18/12/22.
//

import XCTest
@testable import SystemTest

class NetworkAPITest: XCTestCase {
    let apiService = APIService()
        
    func testRandomCatFact_API_CorrectURL() throws {
        let expectation = expectation(description: "APITesting")
        apiService.getRandomCatFact(SERVICE_CATFACT_URL, ["count":"1"], GET_REQUEST) { data, error in
            expectation.fulfill()
            XCTAssertNotNil(data)
        }
        waitForExpectations(timeout: 5)
    }
    
    func testRandomCatFact_API_WrongURL() throws {
        let expectation = expectation(description: "APITesting")
        apiService.getRandomCatFact("https://meowfacts.herokuapp.com/test", ["count":"1"], GET_REQUEST) { data, error in
            expectation.fulfill()
            XCTAssertNil(data)
        }
        waitForExpectations(timeout: 5)
    }
    
    func testRandomCatFact_API_Result_Count() throws {
        let expectation = expectation(description: "APITesting")
        apiService.getRandomCatFact(SERVICE_CATFACT_URL, ["count":"2"], GET_REQUEST) { data, error in
            expectation.fulfill()
            XCTAssertNil(error)
            XCTAssertEqual(2, data?.data?.count)
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetRandomCatImage_API_CorrectURL_withOutImageSize() throws {
        let expectation = expectation(description: "APITesting")
        apiService.getRandomCatImage(SERVICE_CATIMAGE_URL) { imageData, error in
            expectation.fulfill()
            XCTAssertNil(imageData)
        }
        waitForExpectations(timeout: 5)
    }
    
    func testGetRandomCatImage_API_CorrectURL_withProperImageSize() throws {
        let expectation = expectation(description: "APITesting")
        apiService.getRandomCatImage(SERVICE_CATIMAGE_URL + "200/300") { imageData, error in
            expectation.fulfill()
            XCTAssertNotNil(imageData)
        }
        waitForExpectations(timeout: 5)
    }
}
