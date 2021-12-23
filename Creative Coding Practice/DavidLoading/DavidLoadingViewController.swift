//
//  DavidLoadingViewController.swift
//  Creative Coding Practice
//
//  Created by Fomagran on 2021/12/23.
//

import UIKit

class DavidLoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let pinkwall:UIImageView = UIImageView(image: UIImage(named:"pinkwall.png"))
        let david:UIImageView = UIImageView(image: UIImage(named:"david.png"))
        pinkwall.frame = CGRect(x: view.frame.midX-200, y: view.frame.midY-200, width: 400, height: 400)
        view.addSubview(pinkwall)
        david.frame = CGRect(x: view.frame.midX-50, y: view.frame.midY-50, width: 100, height: 100)
        view.addSubview(david)
        pinkwall.transform = pinkwall.transform.rotated(by: -.pi/4)
        david.transform = david.transform.rotated(by: .pi/4)
        let centerY = pinkwall.center.y
        let dot = centerY - (400*sqrt(2)/2)
        david.center = CGPoint(x: view.frame.midX+70, y: dot)
        
    }
}
