//
//  ImageHeaderView.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/12.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import Foundation
import UIKit

class ImageHeaderView: UICollectionReusableView {
    
    static let reuseID = "ImageHeaderView"
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
      super.awakeFromNib()
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
    }

}
