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
    let translationThreshold = CGFloat(75)

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
        //var panPhoto = UIPanGestureRecognizer(target: self, action: "onPanPhoto:")
        //self.photoImageView.addGestureRecognizer(panPhoto)
        
        // scroll setup
        // adapted from www.raywenderlich.com/76436/use-uiscrollview-scroll-zoom-content-swift
        scrollView.delegate = self
        
        let scrollViewFrame = scrollView.frame
        let scaleWidth = scrollViewFrame.size.width / scrollView.contentSize.width
        let scaleHeight = scrollViewFrame.size.height / scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        scrollView.minimumZoomScale = minScale
        
        scrollView.maximumZoomScale = 1.0
        scrollView.zoomScale = minScale
        
        centerScrollViewContents()
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
    
    func centerScrollViewContents() {
        let boundsSize = scrollView.bounds.size
        var contentsFrame = photoImageView.frame
        
        if contentsFrame.size.width < boundsSize.width {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2.0
        } else {
            contentsFrame.origin.x = 0.0
        }
        
        if contentsFrame.size.height < boundsSize.height {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2.0
        } else {
            contentsFrame.origin.y = 0.0
        }
        
        photoImageView.frame = contentsFrame
    }
    
    func scrollViewDoubleTapped(recognizer: UITapGestureRecognizer) {
        // 1
        let pointInView = recognizer.locationInView(photoImageView)
        
        // 2
        var newZoomScale = scrollView.zoomScale * 1.5
        newZoomScale = min(newZoomScale, scrollView.maximumZoomScale)
        
        // 3
        let scrollViewSize = scrollView.bounds.size
        let w = scrollViewSize.width / newZoomScale
        let h = scrollViewSize.height / newZoomScale
        let x = pointInView.x - (w / 2.0)
        let y = pointInView.y - (h / 2.0)
        
        let rectToZoomTo = CGRectMake(x, y, w, h);
        
        // 4
        scrollView.zoomToRect(rectToZoomTo, animated: true)
    }
    
//    func onPanPhoto(gestureRecognizer: UIPanGestureRecognizer){
//        var window = UIApplication.sharedApplication().keyWindow
//        var location = gestureRecognizer.locationInView(view)
//        var translation = gestureRecognizer.translationInView(view)
//        var velocity = gestureRecognizer.velocityInView(view)
//        
//        //println("velocity \(velocity)")
//        
//        if gestureRecognizer.state == UIGestureRecognizerState.Began {
//            // do nothing
//            photoViewOrigin = photoImageView.frame.origin
//            self.doneButton.alpha = 0
//            self.photoActions.alpha = 0
//        }
//        else if gestureRecognizer.state == UIGestureRecognizerState.Changed {
//            self.photoImageView.frame.origin.y = translation.y + photoViewOrigin.y
//            opacity = (1 - abs(translation.y/window.frame.size.height))
//            
//            println(translation.y)
//            self.view.backgroundColor = UIColor(white: 0, alpha: opacity)
//        }
//        else if gestureRecognizer.state == UIGestureRecognizerState.Ended {
//            if (translation.y == 0 || abs(translation.y) <= translationThreshold) {
//                self.doneButton.alpha = 1
//                self.photoActions.alpha = 1
//                UIView.animateWithDuration(0.2) {
//                    self.photoImageView.frame.origin.y = self.photoViewOrigin.y
//                }
//            } else {
//                self.dismissViewControllerAnimated(true, completion: nil)
//            }
//        }
//        
//    }

    func scrollViewDidScroll(scrollView: UIScrollView!) {
        // This method is called as the user scrolls
        
        // hide buttons
        self.doneButton.alpha = 0
        self.photoActions.alpha = 0
        
        // track scroll position
        scrollPosition = self.scrollView.contentOffset.y
        scrollHeight = self.scrollView.contentSize.height
        scrollPercentage = (scrollPosition / scrollHeight) * 2
        
        // set alpha of view
        opacity = (1 - abs(scrollPercentage))
        self.view.backgroundColor = UIColor(white: 0, alpha: opacity)
        
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView!) {
        println("dragging")
        
        // get placement of photo when scrolling starts
        photoViewOrigin = photoImageView.frame.origin
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView!,
        willDecelerate decelerate: Bool) {
        println("lifted your finger")
        println("end photo frame location: \(self.photoImageView.frame.origin.y)")
        if (scrollPosition == 0 || abs(scrollPosition) <= translationThreshold) {
            self.doneButton.alpha = 1
            self.photoActions.alpha = 1
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)
        }
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
