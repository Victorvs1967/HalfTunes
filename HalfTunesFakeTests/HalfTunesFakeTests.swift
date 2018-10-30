//
//  HalfTunesFakeTests.swift
//  HalfTunesFakeTests
//
//  Created by Victor Smirnov on 29/10/2018.
//  Copyright © 2018 Ray Wenderlich. All rights reserved.
//

import XCTest
@testable import HalfTunes

class HalfTunesFakeTests: XCTestCase {
  
  var controllerUnderTest: SearchViewController!

  override func setUp() {
      // Put setup code here. This method is called before the invocation of each test method in the class.
    super.setUp()
    controllerUnderTest = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as? SearchViewController

    let testBundle = Bundle(for: type(of: self))
    let path = testBundle.path(forResource: "abbaData", ofType: "json")
    let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)
    
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    let urlResponse = HTTPURLResponse(url: url!, statusCode: 200, httpVersion: nil, headerFields: nil)
    let sessionMock = URLSessionMock(data: data, response: urlResponse, error: nil)
    
    controllerUnderTest.defaultSession = sessionMock
  }

  override func tearDown() {
      // Put teardown code here. This method is called after the invocation of each test method in the class.
    controllerUnderTest = nil
    super.tearDown()
  }

  func testUpdateSearchResultsParsesData() {
//    given
    let promise = expectation(description: "Status code: 200")
    
//    when
    XCTAssertEqual(controllerUnderTest?.searchResults.count, 0, "searchResult shoud be empty befor the data task run")
    let url = URL(string: "https://itunes.apple.com/search?media=music&entity=song&term=abba")
    let dataTask = controllerUnderTest?.defaultSession.dataTask(with: url!) { data, response, error in
      if let error = error {
        print(error.localizedDescription)
      } else if let httpResponse = response as? HTTPURLResponse {
        if httpResponse.statusCode == 200 {
          promise.fulfill()
          self.controllerUnderTest?.updateSearchResults(data)
        }
      }
    }
    dataTask?.resume()
    waitForExpectations(timeout: 5, handler: nil)
//    then
    XCTAssertEqual(controllerUnderTest?.searchResults.count, 3, "Didn't parse 3 items from fake response")
  }

  func testPerformanceExample() {
      // This is an example of a performance test case.
      self.measure {
          // Put the code you want to measure the time of here.
      }
  }

}
