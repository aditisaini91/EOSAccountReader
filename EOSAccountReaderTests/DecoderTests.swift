//
//  AccountDetailsTests.swift
//  EOSAccountReaderTests
//
//  Created by H231412 on 27.01.20.
//  Copyright © 2020 me. All rights reserved.
//

import XCTest

class DecoderTests: XCTestCase {
    
    
    private let accountDetailsMissingType =  Data("""
        [{
        "account_name": "genialwombat",
        "core_liquid_balance": "13691.7086 EOS",
        "net_limit": {
            "used": 289,
            "available": 99797,
            "max": 100086
        },
        "cpu_limit": {
            "used": 1331,
            "available": 60435,
            "max": 61766
        },
        "ram_quota": 945461,
        "net_weight": 1000,
        "cpu_weight": 7001482,
        "ram_usage": 478325
        }]
        """.utf8)
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testDecoding_missingKey_itThrows() {
        
        XCTAssertThrowsError(try JSONDecoder().decode([AccountDetails].self, from: accountDetailsMissingType)) { error in
            if case .keyNotFound(let key, _)? = error as? DecodingError {
                XCTAssertEqual("voter_info", key.stringValue)
            } else {
                XCTFail("Expected '.keyNotFound' but got \(error)")
            }
        }
    }
    
    
}
