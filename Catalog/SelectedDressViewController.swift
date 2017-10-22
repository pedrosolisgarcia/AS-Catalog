//
//  SelectedDressViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 15/10/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class SelectedDressViewController: UIViewController {
    
    @IBOutlet var ImageView: UIImageView!
    @IBOutlet var closeView: UIButton!
    @IBOutlet var popImageView: UIView!
    
    var dressImage = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.removeFromSuperview()
        self.showAnimate()
        ImageView.image = UIImage(named: dressImage)
    }
    
    override func didReceiveMemoryWarning() {super.didReceiveMemoryWarning()}
    
    @IBAction func closeWindow(sender: UIButton) {
        self.removeAnimate()
    }
    
    func showAnimate()
    {
        view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
        view.alpha = 0.0;
        UIView.animate(withDuration: 0.25, animations: {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        });
    }
    
    func removeAnimate()
    {
        UIView.animate(withDuration: 0.25, animations: {
            self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            self.view.alpha = 0.0;
        }, completion:{(finished : Bool)  in
            if (finished)
            {
                self.view.removeFromSuperview()
            }
        });
    }
}
