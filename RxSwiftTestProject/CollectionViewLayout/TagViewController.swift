//
//  TagViewController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/13.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import UIKit

class TagViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    
    var layout: TagLayout? {
      return collectionView.collectionViewLayout as? TagLayout
    }

    var headerKind: String {
      return layout?.headerKind ?? ""
    }

    var tags: [[String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tags = DataManager.shared.generalTags()
//        collectionView.register(ImageHeaderView.self, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: ImageHeaderView.reuseID)
        collectionView.register(ImageHeaderView.self, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: ImageHeaderView.reuseID)
//        collectionView.register(ImageHeaderView.self, forSupplementaryViewOfKind: headerKind, withReuseIdentifier: ImageHeaderView.reuseID)
        collectionView.register(BasicsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BasicsHeaderView.reuseID)
//        collectionView.register(BasicsHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BasicsHeaderView.reuseID)
        
//        collectionView.register(UINib(nibName: "ImageHeaderView", bundle: nil), forSupplementaryViewOfKind: headerKind , withReuseIdentifier: ImageHeaderView.reuseID)
//        collectionView.register(UINib(nibName: "BasicsHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BasicsHeaderView.reuseID)

        
        collectionView.dataSource = self
        collectionView.alwaysBounceVertical = true
        layout?.delegate = self

    }
    
    @IBAction func addTag(_ sender: Any) {
      // 随机添加一个tag
      let text = DataManager.shared.genernalText()
      tags[0].append(text)
      let indexPath = IndexPath(item: tags[0].count - 1, section: 0)
      collectionView.insertItems(at: [indexPath])
    }
    
    @IBAction func deleteTag(_ sender: Any) {
      let count = tags[0].count
      if count == 0 {
        return
      }
      let indexPath = IndexPath(item: count - 1, section: 0)
      self.tags[0].remove(at: indexPath.row)
      collectionView.performBatchUpdates({ [ weak self] in
        guard let `self` = self else { return }
        self.collectionView.deleteItems(at: [indexPath])
      }, completion: nil)
    }


}

// MARK: - UICollectionViewDataSource

extension TagViewController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return tags.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return tags[section].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TagCell.reuseID, for: indexPath) as! TagCell
    cell.value = tags[indexPath.section][indexPath.row]
    return cell
  }
  
//  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//    switch kind {
//    case UICollectionView.elementKindSectionHeader:
//      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BasicsHeaderView.reuseID, for: indexPath) as! BasicsHeaderView
////      view.titleLabel.text = "HEADER -- \(indexPath.section)"
//      view.backgroundColor = UIColor.randomColor()
//      return view
//    case headerKind:
//      let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: ImageHeaderView.reuseID, for: indexPath) as! ImageHeaderView
//      return view
//    default:
//      fatalError("No such kind")
//    }
//  }
  
}


// MARK: - TagLayoutDelegate

extension TagViewController: TagLayoutDelegate {
  
  func collectionView(_ collectionView: UICollectionView, TextForItemAt indexPath: IndexPath) -> String {
    return tags[indexPath.section][indexPath.row]
  }
  
}


// MARK: - TagCell
class TagCell: UICollectionViewCell {
  
  static let reuseID = "tagCell"
  
  @IBOutlet weak var tagLabel: UILabel!
  
  var value: String = "" {
    didSet{
      tagLabel.text = value
    }
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    backgroundColor = UIColor.randomColor()
    tagLabel.font = UIFont.systemFont(ofSize: 12)
    tagLabel.textColor = UIColor.white
  }
  
}
