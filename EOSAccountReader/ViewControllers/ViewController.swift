//
//  ViewController.swift
//  EOSAccountReader
//
//  Created by H231412 on 23.01.20.
//  Copyright © 2020 me. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var accountTextfield: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //update USD EOS exchange rate 
        EOSUSDConversion.updateRate()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Pass the EOS account name to the Account Detils screen before pushing the view controller
        guard let destinationViewController = segue.destination as? AccountDetailsViewController else { return }
        destinationViewController.accountName = accountTextfield.text ?? "genialwombat"
    }
}

