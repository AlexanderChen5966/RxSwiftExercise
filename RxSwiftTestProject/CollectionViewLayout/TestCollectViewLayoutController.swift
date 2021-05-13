//
//  TestCollectViewLayoutController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/11.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import UIKit

class TestCollectViewLayoutController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var colors: [[UIColor]] = []
    var flowLayout: UICollectionViewFlowLayout? {
        return collectionView.collectionViewLayout as? UICollectionViewFlowLayout
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        colors.append(DataManager.shared.generalColors(8))
        colors.append(DataManager.shared.generalColors(5))
        colors.append(DataManager.shared.generalColors(7))
        collectionView.dataSource = self
        collectionView.delegate = self
        
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
//
//        let itemWidth = (view.bounds.width - 4)/3
//        flowLayout?.itemSize = CGSize(width: itemWidth, height: itemWidth)
//        // 最小行间距
//        flowLayout?.minimumLineSpacing = 1
//        // 最小元素之间的间距
//        flowLayout?.minimumInteritemSpacing = 1
//        flowLayout?.headerReferenceSize = CGSize(width: view.bounds.width, height: 50)
//        flowLayout?.footerReferenceSize = CGSize(width: view.bounds.width, height: 30)


        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(_:)))
        collectionView.addGestureRecognizer(longGesture)
    }
    
    @objc
    func longPressed(_ gesture: UILongPressGestureRecognizer) {
        let position = gesture.location(in: collectionView)
        switch gesture.state {
        case .began:
            if let indexPath = collectionView.indexPathForItem(at: position) {
                collectionView.beginInteractiveMovementForItem(at: indexPath)
            }
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(position)
        case .ended:
            collectionView.endInteractiveMovement()
        default:
            collectionView.cancelInteractiveMovement()
        }
    }

}

// MARK: - UICollectionViewDataSource
extension TestCollectViewLayoutController: UICollectionViewDataSource {
  
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return colors.count
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colors[section].count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BasicsCell.reuseID, for: indexPath) as! BasicsCell
    cell.backgroundColor = colors[indexPath.section][indexPath.row]
    return cell
  }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
           case UICollectionView.elementKindSectionHeader:
             let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BasicsHeaderView.reuseID, for: indexPath) as! BasicsHeaderView
             view.titleLabel.text = "HEADER -- \(indexPath.section)"
             return view
           case UICollectionView.elementKindSectionFooter:
             let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BasicsFooterView.reuseID, for: indexPath) as! BasicsFooterView
//             view.titleLabel.text = "FOOTER -- \(indexPath.section)"
             return view
           default:
             fatalError("No such kind")
           }
    }
}

// MARK: - UICollectionViewDelegate
extension TestCollectViewLayoutController: UICollectionViewDelegate {
    // 设置footer size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = view.bounds.width
        return CGSize(width: width, height: 20)
    }

    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            cell.transform = CGAffineTransform.identity.scaledBy(x: 0.8, y: 0.8)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) else {
            return
        }
        UIView.animate(withDuration: 0.1) {
            cell.transform = CGAffineTransform.identity
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // 修改数据源
        let removedColor = self.colors[sourceIndexPath.section][sourceIndexPath.row]
        self.colors[sourceIndexPath.section].remove(at: sourceIndexPath.row)
        self.colors[destinationIndexPath.section].insert(removedColor, at: destinationIndexPath.row)
    }

}


// MARK: - UICollectionViewDelegateFlowLayout
extension TestCollectViewLayoutController: UICollectionViewDelegateFlowLayout {
    
    // 設定itemsize
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            let itemWidth = (view.bounds.width - 4)/3
            return CGSize(width: itemWidth, height: itemWidth)
        }else if indexPath.section == 1 {
            return CGSize(width: view.bounds.width, height: 50)
        }else {
            let itemWidth = (view.bounds.width - 15)/2
            return CGSize(width: itemWidth, height: itemWidth)
        }
    }
    
    // 設定sectionInset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == 0{
            return UIEdgeInsets(top: 0, left: 1, bottom: 0, right: 1)
        }else if section == 1{
            return .zero
        }else{
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    // 設定minimumLineSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0{
            return 1
        }else if section == 1{
            return 2
        }else{
            return 5
        }
    }
    
    // 設定minimumInteritemSpacing
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if section == 0{
            return 1
        }else if section == 1{
            return 2
        }else{
            return 5
        }
    }
    
    // 設定header size
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let width = view.bounds.width
        if section == 0{
            return CGSize(width: width, height: 30)
        }else if section == 1{
            return CGSize(width: width, height: 50)
        }else{
            return CGSize(width: width, height: 70)
        }
    }
      
}


extension UIColor {
  static func randomColor() -> UIColor{
    let red = CGFloat(arc4random_uniform(255) + 1)
    let green = CGFloat(arc4random_uniform(255) + 1)
    let blue = CGFloat(arc4random_uniform(255) + 1)
    return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
  }
}

class DataManager {
    static let shared = DataManager()
    func generalColors(_ count: Int) -> [UIColor] {
        var colors = [UIColor]()
        for _ in 0..<count{
            colors.append(UIColor.randomColor())
        }
        return colors
    }
    
    let randomText = "了解產品總體發展歷程與佈局模式才知道他們過去經歷了什麼現在為什麼會在這裡以後想往哪裡去尤其知道企業過去做了什麼的好處是先對齊認知除了可以減少雙方溝通成本也能知道對企業而言什麼是重要的因當如何做取捨"
    
    func genernalText() -> String{
      let textCount = randomText.count
      let randomIndex = arc4random_uniform(UInt32(textCount))
      let start = max(0, Int(randomIndex)-7)
      let startIndex = randomText.startIndex
      let step = arc4random_uniform(5) + 2 // 2到5个字
      let startTextIndex = randomText.index(startIndex, offsetBy: start)
      let endTexIndex = randomText.index(startIndex, offsetBy: start + Int(step))
      let text = String(randomText[startTextIndex ..< endTexIndex])
      return text
    }
    
    func generalTags() -> [[String]]{
      var tags1: [String] = []
      var tags2: [String] = []
      var tags3: [String] = []
      
      for i in 0..<50 {
        if i%3 == 0 {
          tags1.append(genernalText())
        }
        if i%2 == 0{
          tags2.append(genernalText())
        }
        tags3.append(genernalText())
      }
      return [tags1,tags2,tags3]
    }
}


class BasicsCell: UICollectionViewCell {
  static let reuseID = "BasicsCell"
}

class BasicsHeaderView: UICollectionReusableView {
  
  static let reuseID = "BasicsHeaderView"
  
  @IBOutlet weak var titleLabel: UILabel!
  override func awakeFromNib() {
    super.awakeFromNib()
    titleLabel.textColor = UIColor.black
    titleLabel.font = UIFont.boldSystemFont(ofSize: 18)
  }
}

class BasicsFooterView: UICollectionReusableView {
  
  static let reuseID = "BasicsFooterView"
  @IBOutlet weak var titleLabel: UILabel!
  
  override func awakeFromNib() {
    super.awakeFromNib()
//    titleLabel.textColor = UIColor.gray
//    titleLabel.font = UIFont.systemFont(ofSize: 14)
  }
}
