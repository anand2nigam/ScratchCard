//
//  ViewController.swift
//  ScratchCard
//
//  Created by Anand Nigam on 22/07/21.
//

import UIKit

class ViewController: UIViewController, ScratchCardDelegate {

    @IBOutlet weak var scratchImageView: ScratchImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        scratchImageView.delegate = self
    }

    func scratchCardEraseProgress(is progress: Double) {
        if progress > 50 {
            UIView.animate(withDuration: 0.5) {
                self.scratchImageView.isHidden = true
            }
        }
    }

}

