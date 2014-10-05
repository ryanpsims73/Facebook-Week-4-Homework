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

    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = photoImageView.image!.size

        // Do any additional setup after loading the view.
        photoImageView.image = selectedImage
        photoImageView.alpha = 0
        photoImageView.contentMode = UIViewContentMode.ScaleAspectFit
        photoImageView.clipsToBounds = true
        
        // pan the photo
        var panPhoto = UIPanGestureRecognizer(target: self, action: "onPanPhoto:")
        self.photoImageView.addGestureRecognizer(panPhoto)
        
        // scroll the photo
        scrollView.delegate = self
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
    
    func onPanPhoto(gestureRecognizer: UIPanGestureRecognizer){
        var window = UIApplication.sharedApplication().keyWindow
        var location = gestureRecognizer.locationInView(view)
        var translation = gestureRecognizer.translationInView(view)
        var velocity = gestureRecognizer.velocityInView(view)
        var opacity = CGFloat()
        let translationThreshold = CGFloat(50)
        
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

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // This method is called as the user scrolls
        println("view did scroll")
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        println("dragging")
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool) {
        println("lifted your finger")
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!) {
        println("stopped scrolling")
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
