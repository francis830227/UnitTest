//
//  JSONHelperTests.swift
//  UniTestDemo
//
//  Created by Francis Tseng on 2017/8/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import XCTest
@testable import UniTestDemo

class JSONHelperTests: XCTestCase {
    
    var helper: JSONHelper?
    
    override func setUp() {
        super.setUp()
        
        helper = JSONHelper()
    }
    
    override func tearDown() {

        helper = nil
        
        super.tearDown()
    }
    
    func testLoadJSON() {
        
        let promise = self.expectation(description: "Load JSON file locally.")
        
        helper!.loadJSON(name: "Demo") { result in
            
            promise.fulfill()
            
            switch result {
                
            case .success(let json):
                
                let object = json as? [String: Any]
                
                XCTAssertNotNil(object)
                
                let message = object!["message"] as? String
                
                XCTAssertEqual(message,
                               "hello")
                
            case .failure(let error):
                
                XCTFail("\(error)") // 同等於XCTAssert(false)
                
            }
            
            
        }
        
        self.wait(for: [ promise ], timeout: 10.0)
        
    
        
    }
    

    
}
