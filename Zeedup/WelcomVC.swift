//
//  WelcomVC.swift
//  Zeedup
//
//  Created by Farhana Khan on 16/05/21.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var nameLbl: UILabel!
    var nameText = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = nameText
        nameLbl.numberOfLines = 0
    }
    

   

}
