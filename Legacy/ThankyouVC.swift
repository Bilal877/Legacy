//
//  ThankyouVC.swift
//  Legacy
//
//  Created by Bilal Zafar on 01/08/2021.
//

import UIKit

class ThankyouVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backToTitleClicked(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController") as! ViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
