//
//  TableViewController2.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/30.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewController2: UIViewController {
    
    typealias SectionOfTestModel = SectionModel<TableViewSection,TableViewItem>

    enum TableViewSection {
        case main
    }

    enum TableViewItem {
        case payment(info: TestPaymentInfoModel)
        case creditCard(info: TestCreditCardInfoModel)
    }

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfTestModel>(configureCell: configureCell)

    
    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfTestModel>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) in
        let copySelf = self
        
        switch item {
        case .payment(let info):
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectPaymentCell1", for: indexPath) as? SelectPaymentCell else {
                return UITableViewCell()
            }
            cell.paymentLabel.text = info.paymentString
            cell.selectImageView.image = info.cellIsSelected ? #imageLiteral(resourceName: "check_single"):#imageLiteral(resourceName: "unchecked")

            return cell
            
        case .creditCard(let info):
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "creditCardItemCell", for: indexPath) as? CreditCardItemCell else {
                return UITableViewCell()
            }
            cell.cardNumberLabel.text = info.creditCardNumString
            cell.cardSelectImageView.image = info.cardCellIsSelected ? #imageLiteral(resourceName: "check_line") : nil
            cell.selectButton.rx.tap.asDriver()
                .drive(onNext:{
//                    print("Button Click")
//                    print("Button Click: \(dataSource)")
//                    print("Button Click: \(tableView)")
//                    print("Button Click: \(indexPath)")
//                    print("Button Click: \(item)")
                    
                    print("paymentModel:\(self.paymentModel)")
                    
                    guard self.paymentModel?.viewModel.paymentID == "credit" else {
                        return
                    }
                    
                    //測試
                    let indexArray = self.subItems1.enumerated().filter({
                        if case .creditCard(_) =  $0.element { return true }; return false
                    }).map({ $0.offset })
                    
                    print("creditCard indexArray:\(indexArray)")

                    
                    switch item  {
                        
                    case .creditCard(let info):
                        copySelf.subItems1[indexPath.row] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: info.creditCardNumString, cardCellIsSelected: true))
                        _ = indexArray.filter { (index) -> Bool in
                            if indexPath.row == index {
                                print("相等：\(index)")
//                                self.creditIndexPath = indexPath.row
                                self.creditModel = CreditType(index:indexPath.row, viewModel:info)
                                return true
                            }else {
                                print("不相等：\(index)")
                            }
                            return false

                        }
                        
                        copySelf.items.accept([SectionOfTestModel(model: .main, items: copySelf.subItems1)])
                        cell.selectButton.isSelected = info.cardCellIsSelected
                        break
                    default:
                        break
                    }
                    
//                    cell.selectButton.isSelected = !cell.selectButton.isSelected
                    let image: UIImage = cell.selectButton.isSelected ? #imageLiteral(resourceName: "check_line"):UIImage()
                    
                    
                    //測試
                    let filtered = self.subItems1.filter({
                        switch $0 {
                        case .payment(info: var data):
//                            data.cellIsSelected = false
                            print("payment select status:\(data.cellIsSelected)")
                            return true
                        default:
                            return false
                        }
                    })
                    
//                    let filtered = self.subItems1.filter({
//                    if case .payment(info: let info) = $0 { return true }; return false })
//                    print("filtered：\(filtered)")

//                    self.subItems1.enumerated().filter { (offset , element) -> Bool in
//
//                        switch element{
//                        case .payment(info: _):
//                            return true
//                        default: return false
//
//                        }
//                    }
                    cell.selectButton.setImage(image, for: .normal)
                    
                }).disposed(by: cell.disposeBag)
            
            return cell
        }
    }

    var items = BehaviorRelay<[SectionOfTestModel]>(value: [])
    var subItems1 = [TableViewItem]()
    
    @IBOutlet weak var tableView: UITableView!
    
    //負責對象銷毀
    let disposeBag = DisposeBag()

    var similarObjects: BehaviorRelay<[TestPaymentInfoModel]> =  BehaviorRelay<[TestPaymentInfoModel]>(value: [])

    var subItems = [TestPaymentInfoModel](){
        didSet{
//            print("change")
        }
    }
    
    typealias SelectPaymentType = (index:Int, viewModel:TestPaymentInfoModel)
    
    var paymentModel:SelectPaymentType? {
        didSet {
            
        }
    }
    
    typealias CreditType = (index:Int, viewModel:TestCreditCardInfoModel)

    var creditModel:CreditType? {
        didSet {
        
            guard let creditModel = creditModel  else {
                return
            }

            guard let oldValue = oldValue, creditModel.index != oldValue.index  else {
                return
            }

            for (rowIndex,rowType) in subItems1.enumerated() {
                switch rowType{
                case .creditCard(info: var model):
                        if model.cardCellIsSelected {
                            print("card cell 被選取")
                            print("card cell 被選取index:\(rowIndex)")
                        }
                        
                        model.cardCellIsSelected = false
                        subItems1[oldValue.index] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: oldValue.viewModel.creditCardNumString, cardCellIsSelected: false))
                        items.accept([SectionOfTestModel(model: .main, items: subItems1)])
                        
                    break
                default:
                    break
                }
            }
        }
    }
    
    var creditIndexPath:Int? {
        didSet{
            
            guard let creditIndexPath = creditIndexPath  else {
                return
            }
            
            print("Credit Current Index:\(creditIndexPath) | Credit Older Index:\(oldValue)")
            
            guard creditIndexPath != oldValue, let oldValue = oldValue else {
                return
            }
            
            for (rowIndex,rowType) in subItems1.enumerated() {
                switch rowType{
                case .creditCard(info: var model):
                        if model.cardCellIsSelected {
                            print("card cell 被選取")
                            print("card cell 被選取index:\(rowIndex)")
                            
                            
                        }
                        
                        model.cardCellIsSelected = false
                        subItems1[oldValue] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: model.creditCardNumString, cardCellIsSelected: false))
                        items.accept([SectionOfTestModel(model: .main, items: subItems1)])

                        
                    break
                default:
                    break
                }
            }

        }
    }
    
    var indexPathRow:Int? {

//    var indexPathRow:Int = 0 {
        didSet{
//            print("change")
            guard let indexPathRow = indexPathRow  else {
                return
            }
            
            print("Current Index:\(indexPathRow) Older Index:\(oldValue)")
            guard indexPathRow != oldValue else {
                return
            }
            
//            for (rowIndex,rowType) in subItems1.enumerated() {
//                switch rowType{
//                case .payment(info: let model):
//                        if model.cellIsSelected {
//                            print("cell 被選取")
//                            print("cell 被選取index:\(rowIndex)")
//                        }
//                    break
//                default:
//                    break
//                }
//            }
            
            if let oldValue = oldValue  {
//                selectItem(indexOfRow: oldValue)

//            if let oldValue = oldValue , oldValue == 0 {
                print("上一個被選取的是信用卡")
//                switch subItems1[indexPathRow]{
//                case .creditCard(info: var model):
//                    print("信用卡列表選取")
//
//                    break
//                default:
//                    break
//                }
            }
            print("選取欄位已改變")

        }
    }
    
    func doSomeing(){
        debugPrint("Current thread in \(#function) is \(Thread.current)")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        let mainQueue = DispatchQueue.main
        let globalQueue = DispatchQueue.global()
        let globalQueueWithQos = DispatchQueue.global(qos: .userInitiated)
        let concurrentQueue = DispatchQueue(label: "customQueue")
        
        
//        let copySelf = self
        
        //Don't Do This
        DispatchQueue.main.async {
            self.doSomeing()
            self.view.backgroundColor = .black
        }
        
        //Do This
        let queue = DispatchQueue(label: "work-queue")
        queue.async {
            self.doSomeing()
        }
        //主線程是用來更新UI使用
        DispatchQueue.main.async {
            self.view.backgroundColor = .black
        }

        var queue1 = DispatchQueue(label: "com.sample.queue", qos:.utility )
        
        
        subItems1 = ([
        .payment(info: TestPaymentInfoModel(paymentID: "credit", paymentString: "信用卡", cellIsSelected: false)),
        .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "000000000000000",creditCardNumIndex: 1)),
        .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "111111111111111",creditCardNumIndex: 2)),
        .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "222222222222222",creditCardNumIndex: 3)),
        .payment(info: TestPaymentInfoModel(paymentID: "line", paymentString: "Line", cellIsSelected: false)),
        .payment(info: TestPaymentInfoModel(paymentID: "apple", paymentString: "Apple", cellIsSelected: false)),
        .payment(info: TestPaymentInfoModel(paymentID: "jkos", paymentString: "街口帳戶", cellIsSelected: false)),

        ])
        items.accept([SectionOfTestModel(model: .main, items: subItems1)])
        items
        .subscribe(onNext: { (array) in
              print(array)
        })
        .disposed(by: disposeBag)

        items.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            self.checkItemIsSelect()
            
            self.selectItem(indexOfRow: indexPath.row)
            
            print("indexPath1:\(indexPath.row)")
            self.indexPathRow = indexPath.row

            })

        
        ////------------------
//        subItems = ([
//            TestPaymentInfoModel(paymentID: "credit", paymentString: "信用卡", cellIsSelected: false),
//            TestPaymentInfoModel(paymentID: "line", paymentString: "Line", cellIsSelected: false),
//            TestPaymentInfoModel(paymentID: "apple", paymentString: "Apple", cellIsSelected: false),
//            TestPaymentInfoModel(paymentID: "jkos", paymentString: "街口帳戶", cellIsSelected: false)
//        ])
//
//
//        similarObjects.accept(subItems)
//
//        similarObjects
//        .subscribe(onNext: { (array) in
//              print(array)
//        })
//        .disposed(by: disposeBag)
//
//        similarObjects.bind(to: tableView.rx.items(cellIdentifier: "selectPaymentCell1")){ row,model,cell in
//            let cell = cell as! SelectPaymentCell
//            cell.paymentLabel.text = model.paymentString
//            cell.selectImageView.image = model.cellIsSelected ? #imageLiteral(resourceName: "check_single"):#imageLiteral(resourceName: "unchecked")
//        }
//
//        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
////                guard indexPath.row == row else {
////                    return
////                }
////                guard indexPath.row == copySelf.indexPathRow else {
////                    return
////                }
//
//                for (rowIndex,_) in copySelf.subItems.enumerated() {
//                    copySelf.subItems[rowIndex].cellIsSelected = false
//                }
//
//                copySelf.subItems[indexPath.row].cellIsSelected = true
//                copySelf.similarObjects.accept(copySelf.subItems)
////                print("indexPath:\(row)")
//                print("indexPath1:\(indexPath.row)")
//                copySelf.indexPathRow = indexPath.row
//
////                print("indexPath info:\(copySelf.subItems[row])")
//
//            })

        
//        tableView.rx.itemSelected.bind { (indexPath) in
//            print("indexPath:\(indexPath.row)")
//            print("indexPath info:\(copySelf.subItems[indexPath.row])")
//
//        }

        
    }
    

}


extension TableViewController2 {
    
    private func checkItemIsSelect(olderIndexPath:Int? = nil){
//        let copySelf = self
        
        for (rowIndex,rowType) in self.subItems1.enumerated() {
            switch rowType{
            case .payment(info: let model):
                    if model.cellIsSelected{
                        print("cell 被選取")
                        self.subItems1[rowIndex] = .payment(info: TestPaymentInfoModel(paymentID: model.paymentID, paymentString: model.paymentString, cellIsSelected: false))
                    }
                break
//            case .creditCard(info: let model):
//                if olderIndexPath == 0 {
//                    print("信用卡付費選取")
//
//                }
//                break
            default:
                break
            }
        }
        
    }
    
    
    func selectItem(indexOfRow:Int){
//        let copySelf = self
        
        switch self.subItems1[indexOfRow]{
            case .payment(info: let model):
        
                self.paymentModel = SelectPaymentType(index:indexOfRow, viewModel:model)
//                copySelf.paymentModel = SelectPaymentType(index:indexOfRow, viewModel:model)

                self.subItems1[indexOfRow] =
                    .payment(info: TestPaymentInfoModel(paymentID: model.paymentID, paymentString: model.paymentString, cellIsSelected: true))
                
                if model.paymentID != "credit" {
                    
                    _ = self.subItems1.enumerated().filter({
                        if case .creditCard(info: let data) =  $0.element {
                            if data.cardCellIsSelected {
                                return true
                            }
                            return false
                            
                        }; return false
                    }).map({
                        switch $0.element {
                            
                        case .creditCard(let data):
                            self.subItems1[$0.offset] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: data.creditCardNumString, creditCardNumIndex: data.creditCardNumIndex, cardCellIsSelected: false))
                            break
                        default: break
                            
                        }
                    })
                    
                    
//                    let filtered = copySelf.subItems1.filter({
//                        switch $0 {
//                        case .creditCard(info: var data):
////                            data.cellIsSelected = false
//                            if data.cardCellIsSelected {
//                                print("有信用卡正被選取")
////                                copySelf.subItems1[1] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: data.creditCardNumString, creditCardNumIndex: data.creditCardNumIndex, cardCellIsSelected: false))
//
//
//                                return true
//                            }
//                            return false
//                        default:
//                            return false
//                        }
//                    })

                }
                self.items.accept([SectionOfTestModel(model: .main, items: self.subItems1)])

                break
            case .creditCard(info: let model):
                
                self.subItems1[indexOfRow] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: model.creditCardNumString, cardCellIsSelected: true))
                self.items.accept([SectionOfTestModel(model: .main, items: self.subItems1)])

                break
        }
        
    }
}
