//
//  NetworkManager.swift
//  EOSAccountReader
//
//  Created by H231412 on 24.01.20.
//  Copyright © 2020 me. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case emptyResponse
}
/**
 Handles the network calls
 */
class NetworkManager{
    private var EOSAccountAPI : URL = URL(string: "https://eos.greymass.com/v1/chain/get_accounts")!
    private var currencyConversionAPI : URL = URL(string: "https://apiv2.bitcoinaverage.com/indices/tokens/ticker/EOSUSD")!
    private let session = URLSession.shared
    
    /**
     Responsible to send the post request to get the EOS account details. Calls the completion block on receiving response.
     */
    func postRequest(accountName : String, completion : @escaping (Result<AccountDetails, NetworkError>)->()) -> Void {
        var request = URLRequest(url: EOSAccountAPI)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let json = ["accounts": [accountName]]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: [])
        let task = session.uploadTask(with: request, from: jsonData) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                let accountDetailsArray = try JSONDecoder().decode([AccountDetails].self, from: data!)
                if accountDetailsArray.isEmpty {
                    completion(.failure(.emptyResponse) )
                } else {
                    completion(.success(accountDetailsArray[0]))
                }
            } catch {
                print(error)
            }
        }
        
        task.resume()
    }
    
    /**
     Calls the get request for retrieving EOS to USD conversion rate. Calls the compeltion block on successfull retrieval.
     */
    func retrieveEOStoUSDConversionRate(completion : @escaping (Float)->()) -> Void {
        
        let task = session.dataTask(with: currencyConversionAPI) { data, response, error in
            
            if error != nil || data == nil {
                print("Client error!")
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                print("Server error!")
                return
            }
            
            guard let mime = response.mimeType, mime == "application/json" else {
                print("Wrong MIME type!")
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data!) as? Dictionary<String, AnyObject> {
                    let rate = json["ask"] as? NSNumber
                    completion(rate!.floatValue)
                }
            } catch {
                print("JSON error: \(error.localizedDescription)")
            }
        }
        
        task.resume()
    }
}
