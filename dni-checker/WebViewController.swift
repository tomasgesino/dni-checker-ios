//
//  WebViewController.swift
//  dni-checker
//
//  Created by Tomas Gesino on 07/10/2019.
//  Copyright © 2019 Tomas Gesino. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
        
    @IBOutlet weak var labelDnu: UILabel!
    
    var stringCodeDni: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stringCodeDniSeparated = stringCodeDni.split(separator: "@")
        
        let dni = String(stringCodeDniSeparated[4])
        
        self.labelDnu.text = dni

    }
    

}
