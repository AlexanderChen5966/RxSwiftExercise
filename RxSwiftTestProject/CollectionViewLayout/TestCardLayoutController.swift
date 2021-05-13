//
//  TestCardLayoutController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/12.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import UIKit

class TestCardLayoutController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    var colors: [UIColor] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        colors = DataManager.shared.generalColors(20)

    }


}


extension TestCardLayoutController: UICollectionViewDataSource {
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicsCell.reuseID, for: indexPath) as! BasicsCell
    cell.backgroundColor = colors[indexPath.row]
    return cell
  }
  
}

