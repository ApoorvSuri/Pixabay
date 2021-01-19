//
//  AnimatedTransitioning.swift
//  FlickrPhotos
//
//  Created by cronycle on 19/05/2019.
//  Copyright © 2019 ApoorvSuri. All rights reserved.
//

import UIKit

class AnimatedTransitioning: NSObject, UIViewControllerAnimatedTransitioning {

    private let durationExpanding = 0.5
    private var presenting = true
    private var dismissCompletion: (() -> Void)?
    var originFrame = CGRect.zero

    func transitionDuration(using context: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.4
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let containerView = transitionContext.containerView
        guard let toView = transitionContext.view(forKey: .to), let detailView = presenting ? toView: transitionContext.view(forKey: .from) else {
            return
        }

        let initialFrame = originFrame
        let finalFrame = detailView.frame
        let xScaleFactor = initialFrame.width / finalFrame.width
        let yScaleFactor = initialFrame.height / finalFrame.height
        let scaleTransform = CGAffineTransform(scaleX: xScaleFactor,
                                               y: yScaleFactor)
        detailView.transform = scaleTransform
        detailView.center = CGPoint( x: initialFrame.midX, y: initialFrame.midY)
        detailView.clipsToBounds = true
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(detailView)
        UIView.animate(withDuration: durationExpanding, delay: 0.0,
                       usingSpringWithDamping: 1.0, initialSpringVelocity: 0.0,
                       animations: {
                        detailView.transform = CGAffineTransform.identity
                        detailView.center = CGPoint(x: finalFrame.midX, y: finalFrame.midY)
        },
                       completion: {_ in
                        transitionContext.completeTransition(true)
        }
        )
    }
}
