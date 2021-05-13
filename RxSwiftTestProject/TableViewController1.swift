//
//  TableViewController1.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/30.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewController1: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    //負責對象銷毀
    let disposeBag = DisposeBag()

    var similarObjects: PublishSubject<[String]> = PublishSubject<[String]>()

    var similarObjects1: BehaviorRelay<[String]> =  BehaviorRelay<[String]>(value: [])
    
//    private lazy var dataSource = RxTableViewSectionedReloadDataSource<[String]>()

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var testArray = [
            "AAA",
            "BBB",
            "CCC",
            "DDD",
        ]
        
        similarObjects1.accept(testArray)
        
        similarObjects1.subscribe(onNext: { (array) in
              print(array)
        })
        .disposed(by: disposeBag)

        similarObjects1.bind(to: tableView.rx.items(cellIdentifier: "InnerCell")) { row, model, cell in

            let cell = cell as! RxInnerButtonCell
            cell.label?.text = "\(model)"

            cell.button.rx.tap.asDriver()
                .drive(onNext: { [weak self] in
                    print("title:\(row) | message:\(model)")
//                        cell.label?.text = "\(element)被點擊"
                    testArray[0] = "EEE"
//                        items = Observable.just(testArray)
//                        self!.tableView.reloadData()
                    self!.similarObjects1.accept(testArray)

                }).disposed(by: cell.disposeBag)

            
        }.disposed(by: disposeBag)

        
        //初始化資料
//        let items = Observable.just([
//            "AAA",
//            "BBB",
//            "CCC",
//            "DDD",
//        ])
        
//        var items = Observable.just(testArray)
//
//        similarObjects.asObservable().subscribe({
//            print($0)
//        })
//
//        similarObjects.onNext(testArray)

        

        
        
//        items
//        .bind(to: tableView.rx.items){
//            
//        }
        
//        items
//            .bind(to: tableView.rx.items) { (tableView, row, element) in
//                //初始化cell
//                let cell = tableView.dequeueReusableCell(withIdentifier: "InnerCell")
//                    as! RxInnerButtonCell
//                cell.label?.text = "\(element)"
//
//                //cell的按鈕點擊事件註冊
//                cell.button.rx.tap.asDriver()
//                    .drive(onNext: { [weak self] in
//                        print("title:\(row) | message:\(element)")
////                        cell.label?.text = "\(element)被點擊"
//                        testArray[0] = "EEE"
////                        items = Observable.just(testArray)
////                        self!.tableView.reloadData()
//                    }).disposed(by: cell.disposeBag)
//
//                return cell
//        }
//        .disposed(by: disposeBag)

    }
    
}
