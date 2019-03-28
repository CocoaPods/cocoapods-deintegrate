//
//  ViewController.swift
//  RemoveTestsTargetProject
//
//  Created by Doug Mead on 3/28/19.
//  Copyright © 2019 Doug Mead. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
        self.view.addSubview(label)
        
        Alamofire.request("https://google.com").response { (res) in
            if let data = res.data {
                let text = String(data: data, encoding: String.Encoding.utf8) ?? res.error?.localizedDescription ?? "??"
                label.text = text
            } else {
                let text = res.error?.localizedDescription ?? "??"
                label.text = text
            }
        }
    }


}
