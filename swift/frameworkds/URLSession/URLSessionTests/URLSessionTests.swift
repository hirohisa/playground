//
//  URLSessionTests.swift
//  URLSessionTests
//
//  Created by Hirohisa Kawasaki on 4/19/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest

class URLSessionTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testExample() {

        let URL = NSURL(string: "http://httpbin.org/get")!
        let request = NSURLRequest(URL: URL)
        let expectation = expectationWithDescription("GET Test")

        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) in
            println(data)
            XCTAssertNotNil(data, "data should not be nil")
            XCTAssertNil(error, "error should be nil")

            if let response = response as? NSHTTPURLResponse {
                XCTAssertEqual(response.statusCode, 200, "HTTP response status code should be 200")
            } else {
                XCTFail("Response was not NSHTTPURLResponse")
            }

            expectation.fulfill()
        })

        task.resume()

        waitForExpectationsWithTimeout(task.originalRequest.timeoutInterval, handler: { error in
            println(error)
        })
    }

}
