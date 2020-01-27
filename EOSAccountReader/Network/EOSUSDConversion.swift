//
//  EOStoUSDConversion.swift
//  EOSAccountReader
//
//  Created by H231412 on 25.01.20.
//  Copyright © 2020 me. All rights reserved.
//

import Foundation

/**
 Provides the updated EOS to USD conversion rate 
 */
class EOSUSDConversion {
    static var rate : Float = 3.5
    
    static func updateRate() -> Void {
        let networkManager = NetworkManager()
        networkManager.retrieveEOStoUSDConversionRate { (conversionrate) in
            EOSUSDConversion.rate = conversionrate
        }
    }
}
