//
//  NewsFeedViewController.swift
//  Facebook
//
//  Created by Timothy Lee on 8/3/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

import UIKit

class NewsFeedViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {
    
    var isPresenting: Bool = true

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var feedImageView: UIImageView!
    
    
    @IBOutlet weak var image1: UIImageView!
    @IBOutlet weak var image2: UIImageView!
    @IBOutlet weak var image3: UIImageView!
    @IBOutlet weak var image4: UIImageView!
    @IBOutlet weak var image5: UIImageView!
    
    var imageViewToSegue: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Configure the content size of the scroll view
        scrollView.contentSize = CGSizeMake(320, feedImageView.image!.size.height)
        
        // associate tap gesture with images
        self.image1.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.image2.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.image3.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.image4.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
        self.image5.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "onTapImage:"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        scrollView.contentInset.top = 0
        scrollView.contentInset.bottom = 50
        scrollView.scrollIndicatorInsets.top = 0
        scrollView.scrollIndicatorInsets.bottom = 50
    }

    // function responding to image tapping
    func onTapImage(gestureRecognizer: UITapGestureRecognizer) {
        imageViewToSegue = gestureRecognizer.view as UIImageView
        self.performSegueWithIdentifier("showImageSegue", sender: self)
    }
    
    // global functions
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
    
    // custom segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        var destinationViewController = segue.destinationViewController as PhotoViewController
        destinationViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        destinationViewController.transitioningDelegate = self
        
        destinationViewController.selectedImage = self.imageViewToSegue.image
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController!, presentingController presenting: UIViewController!, sourceController source: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController!) -> UIViewControllerAnimatedTransitioning! {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        // The value here should be the duration of the animations scheduled in the animationTransition method
        return 0.4
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var containerView = transitionContext.containerView()
        var toViewController = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var fromViewController = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        
        let destinationImageCenter = CGPoint(x: 320/2, y: 284)
        var originImageCenter = self.imageViewToSegue.center
        
        if (isPresenting) {
            println("animating to transition")
            var window = UIApplication.sharedApplication().keyWindow
            // copy image and animate to segue
            var copyImage = UIImageView()
            copyImage.frame = window.convertRect(imageViewToSegue.frame, fromView: scrollView)
            copyImage.image = imageViewToSegue.image
            copyImage.contentMode = UIViewContentMode.ScaleAspectFit
            copyImage.clipsToBounds = true
            
            var scaleFactor = window.frame.width / copyImage.frame.width
            
            // add to parent window
            window.addSubview(copyImage)
            
            containerView.addSubview(toViewController.view)
            toViewController.view.alpha = 0
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                copyImage.clipsToBounds = false
                copyImage.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
                copyImage.center = destinationImageCenter
                toViewController.view.alpha = 1
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    copyImage.removeFromSuperview()
            }
        } else {
            println("animating return transition")
            var photoViewController = fromViewController as PhotoViewController
            //var feedViewController = toViewController as NewsFeedViewController
            
            var window = UIApplication.sharedApplication().keyWindow
            var copyImage = UIImageView()
            var scaleFactor =  self.imageViewToSegue.frame.width / photoViewController.photoImageView.frame.width
            
            copyImage.image = photoViewController.photoImageView.image
            copyImage.contentMode = UIViewContentMode.ScaleAspectFit
            copyImage.clipsToBounds = true
            copyImage.frame = window.convertRect(photoViewController.photoImageView.frame, toView: self.view)
            
            println(photoViewController.photoImageView.frame)
            println(copyImage.frame)
            
            window.addSubview(copyImage)
            
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                copyImage.transform = CGAffineTransformMakeScale(scaleFactor, scaleFactor)
                copyImage.center = originImageCenter;
                fromViewController.view.alpha = 0
                }) { (finished: Bool) -> Void in
                    transitionContext.completeTransition(true)
                    fromViewController.view.removeFromSuperview()
                    copyImage.removeFromSuperview()
            }
        }
    }
}
