//
//  TwoLevelSelectViewController.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/2/6.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TwoLevelSelectViewController: UIViewController {

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
                        
                        guard self.paymentModel?.viewModel.paymentID == "credit" else {
                            return
                        }
                        
                        let indexArray = self.subItems.enumerated().filter({
                            if case .creditCard(_) =  $0.element { return true }; return false
                        }).map({ $0.offset })
                                                
                        switch item  {
                            
                        case .creditCard(let info):
                            copySelf.subItems[indexPath.row] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: info.creditCardNumString, cardCellIsSelected: true))
                            _ = indexArray.filter { (index) -> Bool in
                                if indexPath.row == index {
                                    print("相等：\(index)")
                                    self.creditModel = CreditType(index:indexPath.row, viewModel:info)
                                    return true
                                }else {
                                    print("不相等：\(index)")
                                }
                                return false

                            }
                            
                            copySelf.items.accept([SectionOfTestModel(model: .main, items: copySelf.subItems)])
                            cell.selectButton.isSelected = info.cardCellIsSelected
                            break
                        default:
                            break
                        }
                        
                        let image: UIImage = cell.selectButton.isSelected ? #imageLiteral(resourceName: "check_line"):UIImage()
                        
                        
                        cell.selectButton.setImage(image, for: .normal)
                        
                    }).disposed(by: cell.disposeBag)
                
                return cell
            }
        }

    @IBOutlet weak var tableView: UITableView!
    var items = BehaviorRelay<[SectionOfTestModel]>(value: [])
    var subItems = [TableViewItem]()

    typealias SelectPaymentType = (index:Int, viewModel:TestPaymentInfoModel)
    var paymentModel:SelectPaymentType?
    
    
    typealias CreditType = (index:Int, viewModel:TestCreditCardInfoModel)
    var creditModel:CreditType? {
        didSet {
        
            guard let creditModel = creditModel  else {
                return
            }

            guard let oldValue = oldValue, creditModel.index != oldValue.index  else {
                return
            }

            for (rowIndex,rowType) in subItems.enumerated() {
                switch rowType{
                case .creditCard(info: var model):
                        
                        model.cardCellIsSelected = false
                        subItems[oldValue.index] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: oldValue.viewModel.creditCardNumString, cardCellIsSelected: false))
                        items.accept([SectionOfTestModel(model: .main, items: subItems)])
                        
                    break
                default:
                    break
                }
            }
        }
    }

    //負責對象銷毀
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        let copySelf = self

        subItems = ([
        .payment(info: TestPaymentInfoModel(paymentID: "credit", paymentString: "信用卡", cellIsSelected: false)),
        .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "000000000000000",creditCardNumIndex: 1)),
        .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "111111111111111",creditCardNumIndex: 2)),
        .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "222222222222222",creditCardNumIndex: 3)),
        .payment(info: TestPaymentInfoModel(paymentID: "line", paymentString: "Line", cellIsSelected: false)),
        .payment(info: TestPaymentInfoModel(paymentID: "apple", paymentString: "Apple", cellIsSelected: false)),
        .payment(info: TestPaymentInfoModel(paymentID: "jkos", paymentString: "街口帳戶", cellIsSelected: false)),

        ])
        items.accept([SectionOfTestModel(model: .main, items: subItems)])
        items
        .subscribe(onNext: { (array) in
              print(array)
        })
        .disposed(by: disposeBag)

        items.bind(to: tableView.rx.items(dataSource: dataSource))
        .disposed(by: disposeBag)
        
        tableView.rx.itemSelected.subscribe(onNext: { (indexPath) in
            copySelf.checkItemIsSelect()
            
            copySelf.selectItem(indexOfRow: indexPath.row)

            })

    }
    

}


extension TwoLevelSelectViewController {
    
    func checkItemIsSelect(olderIndexPath:Int? = nil){
        let copySelf = self
        
        for (rowIndex,rowType) in copySelf.subItems.enumerated() {
            switch rowType{
            case .payment(info: let model):
                    if model.cellIsSelected{
                        copySelf.subItems[rowIndex] = .payment(info: TestPaymentInfoModel(paymentID: model.paymentID, paymentString: model.paymentString, cellIsSelected: false))
                    }
                break
            default: break
            }
        }
    }
    
    
    func selectItem(indexOfRow:Int){
        let copySelf = self

        switch copySelf.subItems[indexOfRow]{
            case .payment(info: let model):
                copySelf.paymentModel = SelectPaymentType(index:indexOfRow, viewModel:model)

                copySelf.subItems[indexOfRow] =
                    .payment(info: TestPaymentInfoModel(paymentID: model.paymentID, paymentString: model.paymentString, cellIsSelected: true))
                
                if model.paymentID != "credit" {
                    
                    _ = self.subItems.enumerated().filter({
                        if case .creditCard(info: let data) =  $0.element {
                            if data.cardCellIsSelected {
                                return true
                            }
                            return false
                            
                        }; return false
                    }).map({
                        switch $0.element {
                            
                        case .creditCard(let data):
                            copySelf.subItems[$0.offset] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: data.creditCardNumString, creditCardNumIndex: data.creditCardNumIndex, cardCellIsSelected: false))
                            break
                        default: break
                            
                        }
                    })
                }
                copySelf.items.accept([SectionOfTestModel(model: .main, items: copySelf.subItems)])

                break
            case .creditCard(info: let model):
                
                copySelf.subItems[indexOfRow] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: model.creditCardNumString, cardCellIsSelected: true))
                copySelf.items.accept([SectionOfTestModel(model: .main, items: copySelf.subItems)])
                break
        }
        
    }
}
