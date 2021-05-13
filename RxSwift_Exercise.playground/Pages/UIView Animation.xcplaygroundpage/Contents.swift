import Foundation
import UIKit
import XCPlayground

let v = UIView()
v.frame.size = CGSize(width: 200, height: 200)
v.backgroundColor = UIColor.red
v.layer.cornerRadius = 100

//UIView.animateKeyframes(withDuration: 1, delay: 0, options: .repeat, animations: {
//    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.5, animations: {
//      v.alpha = 0.0
//    })
//    UIView.addKeyframe(withRelativeStartTime: 0.5, relativeDuration: 0.5, animations: {
//      v.alpha = 0.5
//    })
//    }, completion: nil)
//
//XCPlaygroundPage.currentPage.liveView = v

UIView.beginAnimations(nil, context: nil)
UIView.setAnimationDuration(10.0)
var point:CGPoint = v.center
point.y += 150
v.center = point
UIView.commitAnimations()
XCPlaygroundPage.currentPage.liveView = v

