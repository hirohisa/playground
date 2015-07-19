//
//  DispatchSampleTests.swift
//  DispatchSampleTests
//
//  Created by Hirohisa Kawasaki on 7/20/15.
//  Copyright (c) 2015 Hirohisa Kawasaki. All rights reserved.
//

import UIKit
import XCTest

class DispatchSampleTests: XCTestCase {

    let concurrent = dispatch_queue_create(nil, DISPATCH_QUEUE_CONCURRENT)
    let serial = dispatch_queue_create(nil, DISPATCH_QUEUE_SERIAL)
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDispatch() {
        let expectation = expectationWithDescription("try dispatch")

        async_main {
            expectation.fulfill()
        }

        waitForExpectationsWithTimeout(10, handler: { error in
            if let error = error {
                XCTAssertTrue(false, "expectations are still finished")
            }
        })
    }

    func async_main(block: () -> ()) {
        dispatch_async(dispatch_get_main_queue()) {
            block()
        }
    }

    func async_concurrent(block: () -> ()) {

    }

}
