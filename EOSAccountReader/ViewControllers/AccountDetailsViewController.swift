//
//  AccountDetailsViewController.swift
//  EOSAccountReader
//
//  Created by H231412 on 24.01.20.
//  Copyright © 2020 me. All rights reserved.
//


import UIKit

class AccountDetailsViewController: UIViewController {
    
    @IBOutlet weak var EOSbalance: UILabel!
    @IBOutlet weak var USDBalance: UILabel!
    @IBOutlet weak var stakedEOS: UILabel!
    
    @IBOutlet weak var cpuConsumption: UILabel!
    @IBOutlet weak var stakedCPU: UILabel!
    @IBOutlet weak var cpuConsumptionPercentage: UILabel!
    @IBOutlet weak var cpuProgressView: UIProgressView!
    
    @IBOutlet weak var netConsumption: UILabel!
    @IBOutlet weak var stakedNET: UILabel!
    @IBOutlet weak var netConsumptionPercentage: UILabel!
    @IBOutlet weak var netProgressView: UIProgressView!
    
    @IBOutlet weak var ramConsumption: UILabel!
    @IBOutlet weak var ramConsumptionPercentage: UILabel!
    @IBOutlet weak var ramProgressView: UIProgressView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var accountName : String = "genialwombat"   //Comes from the previous controller
    private var networkManager = NetworkManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //On the network call response, update the UI
        netorkCalls()
    }
    
    func netorkCalls() -> Void {
        //network api call
        
        self.activityIndicator.startAnimating()
        
        networkManager.postRequest(accountName: accountName, completion: {[weak self](result)  in
            switch result {
            case .success(let accountDetails):
                DispatchQueue.main.async {
                    self?.EOSbalance.text = accountDetails.balance;
                    self?.USDBalance.text = "= " + accountDetails.usdBalance + "$";
                    
                    self?.stakedEOS.text = String(accountDetails.voterInfo.stakedEOS);
                    
                    self?.stakedCPU.text = String(accountDetails.cpuWeight)
                    self?.cpuConsumption.text = String(roundf(accountDetails.cpuLimit.used)) + "/" + String(roundf(accountDetails.cpuLimit.available))
                    self?.cpuConsumptionPercentage.text = String(roundf((accountDetails.cpuLimit.used / accountDetails.cpuLimit.available) * 100) ) + "%"
                    self?.cpuProgressView.progress = (accountDetails.cpuLimit.used / accountDetails.cpuLimit.available)
                    
                    self?.stakedNET.text = String(accountDetails.netWeight)
                    self?.netConsumption.text = String(roundf(accountDetails.netLimit.used / 1000)) + "/" + String(roundf(accountDetails.netLimit.available / 1000)) + "KB"
                    self?.netConsumptionPercentage.text = String(roundf((accountDetails.netLimit.used / accountDetails.netLimit.available) * 100) ) + "%"
                    self?.netProgressView.progress = (accountDetails.netLimit.used / accountDetails.netLimit.available)
                    
                    self?.ramConsumption.text = String(roundf(accountDetails.ramUsage / 1000)) + "/" + String(roundf(accountDetails.ramQuota / 1000)) + "KB"
                    self?.ramConsumptionPercentage.text = String(roundf((accountDetails.ramUsage / accountDetails.ramQuota) * 100 )) + "%"
                    self?.ramProgressView.progress = (accountDetails.ramUsage / accountDetails.ramQuota)
                    
                    self?.activityIndicator.stopAnimating()
                }
            case .failure(let error):
                print(error.localizedDescription)
                DispatchQueue.main.async {
                    self?.activityIndicator.stopAnimating()
                }
            }
            
            }
        )
    }
}

