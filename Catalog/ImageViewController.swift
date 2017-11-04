//
//  ImageViewController.swift
//  Catalog
//
//  Created by Pedro Solís García on 06/10/17.
//  Copyright © 2017 AppCoda. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var zoomInView : UIScrollView!
    @IBOutlet weak var dressImageView: UIImageView!
    @IBOutlet weak var zoomOutButton: UIButton!
    var dress = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.removeFromSuperview()
        self.showAnimate()
        zoomInView.delegate = self
        dressImageView.image = UIImage(named: dress)
        zoomOutButton.isEnabled = true
        zoomOutButton.alpha = 0.75
        setupGestureRecognizer()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated);
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return dressImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if zoomInView.zoomScale == zoomInView.minimumZoomScale {
            zoomOutButton.isEnabled = true
            zoomOutButton.alpha = 0.75
        } else {
            zoomOutButton.isEnabled = false
            zoomOutButton.alpha = 0
        }
    }
    
    func setupGestureRecognizer() {
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector (handleDoubleTap))
        doubleTap.numberOfTapsRequired = 2
        zoomInView.addGestureRecognizer(doubleTap)
    }
    
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        
        if zoomInView.zoomScale > zoomInView.minimumZoomScale {
            zoomInView.setZoomScale(zoomInView.minimumZoomScale, animated: true)
        } else {

            let touchPoint = recognizer.location(in: view)
            let scrollViewSize = zoomInView.bounds.size
            
            let width = scrollViewSize.width / zoomInView.maximumZoomScale
            let height = scrollViewSize.height / zoomInView.maximumZoomScale
            let x = touchPoint.x - (width/2.0)
            let y = touchPoint.y - (height/2.0)
            
            let rect = CGRect(x:x,y:y,width:width,height:height)
            zoomInView.zoom(to: rect, animated: true)
        }
        
    }
    
    @IBAction func zoomOut(sender: UIButton) {
        self.removeAnimate()
        self.navigationController?.isNavigationBarHidden = false
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
                self.dressImageView.image = nil
                self.view.removeFromSuperview()
                self.dismiss(animated: false)
            }
        });
    }
}
