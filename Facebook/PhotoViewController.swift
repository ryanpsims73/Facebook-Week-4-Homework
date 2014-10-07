//
//  PhotoViewController.swift
//  facebookDemo
//
//  Created by Ryan Sims on 10/4/14.
//  Copyright (c) 2014 Ryan Sims. All rights reserved.
//

import UIKit

class PhotoViewController: UIViewController, UIScrollViewDelegate {
    var selectedImage: UIImage!

    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var photoActions: UIImageView!
    
    var photoViewOrigin = CGPoint()
    
    var scrollPosition = CGFloat()
    var scrollHeight = CGFloat()
    var scrollPercentage = CGFloat()
    var opacity = CGFloat()
    var imageZoomed: Bool = false

    let translationThreshold = CGFloat(50)

    override func viewDidLoad() {
        super.viewDidLoad()

        // configure image
        let imageOffsetY = photoImageView.frame.origin.y
        // Configure the content size of the scroll view
        scrollView.contentSize = photoImageView.image!.size

        // Do any additional setup after loading the view.
        photoImageView.image = selectedImage
        photoImageView.frame.origin = CGPoint(x: 0, y: imageOffsetY)
        //photoImageView.frame.size = selectedImage.size
        photoImageView.alpha = 0
        photoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        photoImageView.clipsToBounds = true
        
        // pan the photo
        var panPhoto = UIPanGestureRecognizer(target: self, action: "onPanPhoto:")
        self.photoImageView.addGestureRecognizer(panPhoto)
        
        // tap that photo
        var tapPhoto = UITapGestureRecognizer(target: self, action: "photoViewDoubleTapped:")
        tapPhoto.numberOfTapsRequired = 2
        self.photoImageView.addGestureRecognizer(tapPhoto)

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        photoImageView.alpha = 1
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doneButtonTap(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
    func photoViewDoubleTapped(recognizer: UITapGestureRecognizer) {

        let pointInView = recognizer.locationInView(view)
        var zoomScale = CGFloat(2.0)

        var offSetX = self.photoImageView.center.x - pointInView.x
        var offSetY = self.photoImageView.center.y - pointInView.y
        
        if !imageZoomed {
            UIView.animateWithDuration(0.4){
                // center the photo to tapped point
                // using offsets
                self.photoImageView.frame.origin.x += offSetX
                self.photoImageView.frame.origin.y += offSetY

                // zoom photo
                self.photoImageView.transform = CGAffineTransformMakeScale(zoomScale, zoomScale)

                // hide action buttons in zoom mode
                self.doneButton.alpha = 0
                self.photoActions.alpha = 0
            }
            // store that we're zoomed
            self.imageZoomed = true
        } else {
            UIView.animateWithDuration(0.4){
                // zoom photo
                self.photoImageView.transform = CGAffineTransformMakeScale(1, 1)

                // place photo back to original location
                self.photoImageView.frame.origin.x = 0
                self.photoImageView.frame.origin.y = 44
                
                // show action buttons in zoom mode
                self.doneButton.alpha = 1
                self.photoActions.alpha = 1
            }
            self.imageZoomed = false
        }
        
//        
//        // 3
//        let scrollViewSize = scrollView.bounds.size
//        let w = scrollViewSize.width / newZoomScale
//        let h = scrollViewSize.height / newZoomScale
//        let x = pointInView.x - (w / 2.0)
//        let y = pointInView.y - (h / 2.0)
//        
//        let rectToZoomTo = CGRectMake(x, y, w, h);
//        
//        // 4
//        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
    func onPanPhoto(gestureRecognizer: UIPanGestureRecognizer){
        var window = UIApplication.sharedApplication().keyWindow
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)
        
        //println("velocity \(velocity)")
        
        if gestureRecognizer.state == UIGestureRecognizerState.Began {
            // do nothing
            photoViewOrigin = photoImageView.frame.origin
            self.doneButton.alpha = 0
            self.photoActions.alpha = 0
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
            self.photoImageView.frame.origin.y = translation.y + photoViewOrigin.y
            opacity = (1 - abs(translation.y/window.frame.size.height))
            
            println(translation.y)
            self.view.backgroundColor = UIColor(white: 0, alpha: opacity)
        }
        else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
            if (translation.y == 0 || abs(translation.y) <= translationThreshold) {
                self.doneButton.alpha = 1
                self.photoActions.alpha = 1
                UIView.animateWithDuration(0.2) {
                    self.photoImageView.frame.origin.y = self.photoViewOrigin.y
                }
            } else {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
