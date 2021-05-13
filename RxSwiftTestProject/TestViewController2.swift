//
//  TestViewController2.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2021/1/8.
//  Copyright © 2021 AlexanderChen. All rights reserved.
//

import UIKit

@available(iOS 14.0, *)
class TestViewController2: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    typealias DataSource = UICollectionViewDiffableDataSource<String, String>
    typealias Snapshot = NSDiffableDataSourceSnapshot<String, String>
    
    private lazy var dataSource:DataSource = makeDataSource()
    private lazy var dataSource1:DataSource = makeDataSource1()

    var items = Array(0...100).map { String($0) }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        //iOS 13
//        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
//        collectionView.dataSource = dataSource

        //iOS 14
        let config = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        collectionView.collectionViewLayout = layout
        collectionView.dataSource = dataSource1

        
        var snapshot = Snapshot()
        snapshot.appendSections(["Section 1"])
        snapshot.appendItems(items)
//        dataSource.apply(snapshot, animatingDifferences: true)
        dataSource1.apply(snapshot, animatingDifferences: true)

    }
    
}


@available(iOS 14.0, *)
extension TestViewController2 {
    //iOS 13 need
    //collectionView.register(Cell.self, forCellWithReuseIdentifier: "Foo")
    //and
    //collectionView.dequeueReusableCell(withReuseIdentifier: "Foo", for: indexPath) as! Cell

    func makeDataSource() -> DataSource {
      // 1
      let dataSource = DataSource(
        collectionView: collectionView,
        cellProvider: { (collectionView, indexPath, video) ->
          UICollectionViewCell? in
          // 2
          let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "Cell",
            for: indexPath)
          return cell
        })
      return dataSource
    }
    
    //iOS 14 可以使用CellRegistration做基本的佈局
    func makeDataSource1() -> DataSource {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, String> { cell, indexPath, name in
            
            var content = cell.defaultContentConfiguration()
            content.text = name
        
            cell.contentConfiguration = content
        }

        
      let dataSource = DataSource(
        collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
        collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
      }
        
      return dataSource
    }

}
