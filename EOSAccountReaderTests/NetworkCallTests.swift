//
//  EOSAccountReaderTests.swift
//  EOSAccountReaderTests
//
//  Created by H231412 on 23.01.20.
//  Copyright © 2020 me. All rights reserved.
//

import XCTest
@testable import EOSAccountReader

class NetworkCallTests: XCTestCase {
    let networkManager = NetworkManager()
    var urlSession: URLSession!
    
    override func setUp() {
        urlSession = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        urlSession = nil
    }
    
    func testSuccessfulResponse() {
        
        let testBundle = Bundle(for: type(of: self))
        let path = testBundle.path(forResource: "FakeTestJsonInput", ofType: "json")
        let data = try? Data(contentsOf: URL(fileURLWithPath: path!), options: .alwaysMapped)        
        let accountDetailsFromJSONFile = try? JSONDecoder().decode([AccountDetails].self, from: data!)
        let accountDetailFromJSONFile : AccountDetails = (accountDetailsFromJSONFile?[0])!
        
        networkManager.postRequest(accountName: "genialwombat", completion: {(result)  in
            switch result {
            case .success(let accountDetail):
                XCTAssertEqual(accountDetail, accountDetailFromJSONFile )
            case .failure(let error):
                print(error)
            }
        })
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToEOSApi() {
        let url = URL(string: "https://eos.greymass.com/v1/chain/get_accounts")
        let expectations = expectation(description: "Status code: 200")
        
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["accounts": ["genialwombat"]]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        let task = urlSession.uploadTask(with: request, from: jsonData) { data, response, error in
            
            if let error = error {
                XCTFail("Error: \(error.localizedDescription)")
                return
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    expectations.fulfill()
                } else {
                    XCTFail("Status code: \(statusCode)")
                }
            }
        }
        task.resume()
        wait(for: [expectations], timeout: 5)
    }
    
    // Asynchronous test: success fast, failure fast
    func testValidCallToEOSApiCompletes() {
        let url = URL(string: "https://eos.greymass.com/v1/chain/get_accounts")
        let expectations = expectation(description: "Completion handler invoked")
        var statusCode: Int?
        var responseError: Error?
        
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["accounts": ["genialwombat"]]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        
        let task = urlSession.uploadTask(with: request, from: jsonData) { data, response, error in
            statusCode = (response as? HTTPURLResponse)?.statusCode
            responseError = error
            expectations.fulfill()
        }
        task.resume()
        wait(for: [expectations], timeout: 5)
        
        XCTAssertNil(responseError)
        XCTAssertEqual(statusCode, 200)
    }
    
    
}
