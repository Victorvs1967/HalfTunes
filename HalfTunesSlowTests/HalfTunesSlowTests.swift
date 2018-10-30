//
//  HalfTunesSlowTests.swift
//  HalfTunesSlowTests
//
//  Created by Victor Smirnov on 28/10/2018.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

class HalfTunesSlowTests: XCTestCase {
  
  var sessionUnderTest: URLSession!

  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    sessionUnderTest = URLSession(configuration: .default)
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
    sessionUnderTest = nil
    super.tearDown()
  }
  
  func testValidCallToiTunesGetsStatusCode200() {
    //    given
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    let promise = expectation(description: "Status code: 200")
    //    when
    let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
    //    then
        if let error = error {
          XCTFail("Error: \(error.localizedDescription)")
          return
        } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
          if statusCode == 200 {
            promise.fulfill()
          } else {
            XCTFail("Status code: \(statusCode)")
          }
        }
  }
    dataTask.resume()
    waitForExpectations(timeout: 5, handler: nil)
  }

  func testCallToiTunesCompletes() {
    //  given
    let url = URL(string: "https://itune.apple.com/search?media=music&entity=song&term=abba")
    let promise = expectation(description: "Complation handler invoked")
    var statusCode: Int?
    var responseError: Error?
    //  when
    let dataTask = sessionUnderTest.dataTask(with: url!) { data, response, error in
      statusCode = (response as? HTTPURLResponse)?.statusCode
      responseError = error
      promise.fulfill()
    }
    dataTask.resume()
    waitForExpectations(timeout: 5, handler: nil)
    //  then
    XCTAssertNil(responseError)
    XCTAssertEqual(statusCode, 200)
  }

  func testPerformanceExample() {
    // This is an example of a performance test case.
    self.measure {
        // Put the code you want to measure the time of here.
    }
  }
}
