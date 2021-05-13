//
//  SegmentViewController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/2/7.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit

class CustomSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
//        fallBackToPreIOS13Layout(using: .red)
        
        layer.cornerRadius = self.bounds.size.height / 2.0
        
        layer.borderColor = UIColor.red.cgColor
        layer.borderWidth = 1.0
        layer.masksToBounds = true
        clipsToBounds = true
        
        
        for i in 0...subviews.count - 1{
            if let subview = subviews[i] as? UIImageView{
                if i == self.selectedSegmentIndex {
                    subview.backgroundColor = UIColor.red
                }else{
                    subview.backgroundColor = .white
                }
            }
        }
    }
    
    func fallBackToPreIOS13Layout(using tintColor: UIColor) {
          if #available(iOS 13, *) {

              let backGroundImage = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
              let dividerImage = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))

              setBackgroundImage(backGroundImage, for: .normal, barMetrics: .default)
              setBackgroundImage(dividerImage, for: .selected, barMetrics: .default)

              setDividerImage(dividerImage,
                              forLeftSegmentState: .normal,
                              rightSegmentState: .normal, barMetrics: .default)

              layer.borderWidth = 1
              layer.borderColor = tintColor.cgColor
              setTitleTextAttributes([.foregroundColor: tintColor], for: .normal)
              setTitleTextAttributes([.foregroundColor: UIColor.white], for: .selected)
              
      //        layoutSubviews()
//              layoutIfNeeded()
//              layer.cornerRadius = self.bounds.size.height / 2.0

          } else {
              self.tintColor = tintColor
          }
    }
}

extension UIImage {

    convenience init?(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        guard let ctx = UIGraphicsGetCurrentContext() else { return nil }
        ctx.fill(CGRect(origin: .zero, size: size))
        guard
            let image = UIGraphicsGetImageFromCurrentImageContext(),
            let imagePNGData = image.pngData()
            else { return nil }
        UIGraphicsEndImageContext()

        self.init(data: imagePNGData)
       }
}

class SegmentViewController: UIViewController {

    @IBOutlet weak var segmentControl: CustomSegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}
