//
//  SelectedDressViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 15/10/17.
//  Copyright © 2017 VILHON Technologies. All rights reserved.
//

import UIKit

class SelectedDressViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var ImageView: UIImageView!
    @IBOutlet weak var closeView: UIButton!
    @IBOutlet weak var popImageView: UIView!
    
    var dressImage: UIImage!
    
    override func viewDidLoad() -> Void {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self,action: #selector(removeAnimate))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        
        self.view.removeFromSuperview()
        self.popImageView.addViewShadow()
        self.showAnimated()
        ImageView.image = dressImage
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return touch.view === self.view
    }
    
    @IBAction func closeWindow(sender: UIButton) -> Void {
        self.removeAnimated()
    }
    
    @objc func removeAnimate() -> Void {
        self.removeAnimated()
    }
}
