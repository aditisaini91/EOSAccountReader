//
//  AccountDetails.swift
//  EOSAccountReader
//
//  Created by H231412 on 24.01.20.
//  Copyright © 2020 me. All rights reserved.
//

import Foundation


struct AccountDetails : Decodable,Equatable {
    let name: String
    let balance: String
    let cpuLimit: CpuLimit
    let netLimit: NetLimit
    let netWeight: Float
    let cpuWeight: Float
    let ramUsage: Float
    let ramQuota: Float
    let voterInfo : VoterInfo
    
    var usdBalance : String {
        var eos : String = balance
        if eos.hasSuffix(" EOS") {
            eos = String(eos.dropLast(4))
        }
        let usdvalue = Float(eos)! * EOSUSDConversion.rate
        
        return String(usdvalue)
    }
    
    private enum CodingKeys : String, CodingKey {
        case name = "account_name",
        balance = "core_liquid_balance",
        cpuLimit = "cpu_limit",
        netLimit = "net_limit",
        netWeight = "net_weight",
        cpuWeight = "cpu_weight",
        ramUsage = "ram_usage",
        ramQuota = "ram_quota",
        voterInfo = "voter_info"
        
    }
    
    static func ==(lhs: AccountDetails, rhs: AccountDetails) -> Bool {
        return lhs.name == rhs.name
    }
    
}

struct NetLimit : Decodable {
    let used: Float
    let available: Float
    
}

struct CpuLimit : Decodable {
    let used: Float
    let available: Float
    
}

struct VoterInfo : Decodable {
    let stakedEOS: Float
    
    private enum CodingKeys : String, CodingKey {
        case stakedEOS = "staked"
    }
}
