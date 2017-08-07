//
//  CalculatorTests.swift
//  UniTestDemo
//
//  Created by Francis Tseng on 2017/8/7.
//  Copyright © 2017年 Francis Tseng. All rights reserved.
//

import XCTest
@testable import UniTestDemo

class CalculatorTests: XCTestCase {
    
    //假設這樣東西存在 直接繼續往下做
    var calculator: Calculator?
    
    
    //類似viewDidLoad
    override func setUp() {
        super.setUp()
        
        calculator = Calculator()
    }
    
    //程式結束後把程式殺掉
    override func tearDown() {
        
        calculator = nil
        
        super.tearDown()
        
    }
    
    func testAdd() {
        
        let result = calculator!.add(3, 5)
        
        XCTAssertEqual(
            result,
            8
        )
        
    }
    
    func testTime() {
        
        XCTAssertEqual(calculator!.time(4, 3),
                       12)
        
        XCTAssertEqual(calculator!.time(3, 4),
                       12)
        
    }
    
    
}
