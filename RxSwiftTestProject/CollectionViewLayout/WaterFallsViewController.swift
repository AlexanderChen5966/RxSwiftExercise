//
//  WaterFallsViewController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/13.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import UIKit

class WaterFallsViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!

    var layout: WaterFallsLayout? {
      return collectionView.collectionViewLayout as? WaterFallsLayout
    }

    var colors: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        layout?.delegate = self
        collectionView.dataSource = self
        colors = DataManager.shared.generalColors(30)
        layout?.minimumInteritemSpacing = 5
        layout?.minimumLineSpacing = 5

    }
    


}

// MARK: - WaterFallsLayoutDelegate
extension WaterFallsViewController: WaterFallsLayoutDelegate {
  
  func collectionView(_ collectionView: UICollectionView, heightForItemAt indexPath: IndexPath) -> CGFloat {
    let random = arc4random_uniform(4) + 2
    return CGFloat(random * 50)
  }
  
}


// MARK: - UICollectionViewDataSource
extension WaterFallsViewController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicsCell.reuseID, for: indexPath) as! BasicsCell
    cell.backgroundColor = colors[indexPath.row]
    return cell
  }
}
