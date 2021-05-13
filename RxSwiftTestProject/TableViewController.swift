//
//  TableViewController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/9.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    
//    let musicViewModel = MusicListViewModel()//傳統式編程ViewModel
//
//    let musicViewRxModel = MusicListViewRxModel()//響應式編程ViewModel
    //負責對象銷毀
    let disposeBag = DisposeBag()
    
    
    private var viewModel = TestCardInfoViewModel()

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfTestModel>(configureCell: configureCell)

    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfTestModel>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) in
        
        switch item {
        case .payment(let info):
            return self.configStudentCell(student: info, atIndex: indexPath)
        case .creditCard(let info):
            return self.configTeacherCell(teacher: info, atIndex: indexPath)
        }
    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.rx.setDelegate(self).disposed(by: disposeBag)
        //tableView.bounces = false
        let copySelf = self
        viewModel.items
        .bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)

        viewModel.getInformation()

        
//        tableView.rx.itemSelected.asDriver()
//            .drive { _ in
//
//        }
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
                print("indexPath:\(indexPath)")
//
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell") as! SelectPaymentCell
            
            print("indexPath info:\(copySelf.viewModel.getCellInformation(indexPath: indexPath.row))")

        })

        
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        //響應式編程
//        musicViewRxModel.rxData.bind(to: tableView.rx.items(cellIdentifier:"musicCell")){_,music,cell in
//
//            cell.textLabel?.text = "\(music.name) / \(music.singer)"
//
//        }
//        .disposed(by: disposeBag)
//
//        tableView.rx.modelSelected(Music.self).subscribe(onNext: { (music) in
//            print("你選中的歌曲訊息【\(music)】")
//        })
//        .disposed(by: disposeBag)
        
        /*
         1. DisposeBag：作用是Rx在視圖控制器或者其持有者將要銷毀的時候，自動釋法掉綁定在它上面的資源。它是通過類似“ 訂閱處置機制 ”方式實現（類似於NotificationCenter的removeObserver）。
         
         2. rx.items(cellIdentifier:） :這是Rx基於cellForRowAt數據源方法的一個封裝。傳統方式中我們還要有個numberOfRowsInSection方法，使用Rx後就不再需要了（Rx已經幫我們完成了相關工作）。
         
         3. rx. modelSelected：這是Rx基於UITableView委託回調方法didSelectRowAt的一個封裝。
         */
        
    }

}

//傳統式編程
//extension TableViewController: UITableViewDelegate {
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//
//        print("你選中的歌曲訊息【\(musicViewModel.data[indexPath.row])】")
//    }
//
//}
//
//extension TableViewController: UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return musicViewModel.data.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
//        let music = musicViewModel.data[indexPath.row]
//        cell.textLabel?.text = "\(music.name) / \(music.singer)"
//        return cell
//    }
//}


extension TableViewController {
    
    func configStudentCell(student: TestPaymentInfoModel, atIndex: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "selectPaymentCell", for: atIndex) as? SelectPaymentCell else {
            return UITableViewCell()
        }
        cell.viewModel = student
        return cell
    }
    
    func configTeacherCell(teacher: TestCreditCardInfoModel, atIndex: IndexPath) -> UITableViewCell {
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "creditCardItemCell", for: atIndex) as? CreditCardItemCell else {
            return UITableViewCell()
        }
        cell.viewModel = teacher
        return cell
    }
    
}
