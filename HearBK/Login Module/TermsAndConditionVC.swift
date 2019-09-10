//
//  TermsAndConditionVC.swift
//  HearBK
//
//  Created by Amisha on 16/10/18.
//  Copyright © 2018 Amisha. All rights reserved.
//

import UIKit

class TermsAndConditionVC: UIViewController {

    @IBOutlet var termsWebview: UIWebView!
    
    var pdfSelection : String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let pdfFilePath = Bundle.main.url(forResource: pdfSelection, withExtension: "pdf")
        let urlRequest = URLRequest.init(url: pdfFilePath!)
        self.termsWebview.loadRequest(urlRequest)
        
    }
    
    @IBAction func clickToBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        
    }

}
