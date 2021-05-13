//
//  TableViewController3.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/31.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewController3: UIViewController {
    
    typealias selectPaymentType = (index:IndexPath, isSelected:Bool, viewModel:TestPaymentInfoModel)
    typealias creditType = (index:IndexPath, isSelected:Bool, viewModel:TestCreditCardInfoModel)

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
                    print("Button Click")
                    cell.selectButton.isSelected = !cell.selectButton.isSelected
                    let image: UIImage = cell.selectButton.isSelected ? #imageLiteral(resourceName: "check_line"):UIImage()
                    
                    cell.selectButton.setImage(image, for: .normal)
                    
                }).disposed(by: cell.disposeBag)
            
            return cell
        }
    }

    var items = BehaviorRelay<[SectionOfTestModel]>(value: [])
    var subItems = [TableViewItem]()

    @IBOutlet weak var tableView: UITableView!

    //負責對象銷毀
    let disposeBag = DisposeBag()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    


}


extension TableViewController3 {
    
    func checkItemIsSelect(olderIndexPath:Int? = nil){
        let copySelf = self
        
        for (rowIndex,rowType) in copySelf.subItems.enumerated() {
            switch rowType{
            case .payment(info: let model):
                    if model.cellIsSelected{
                        print("cell 被選取")
                        copySelf.subItems[rowIndex] = .payment(info: TestPaymentInfoModel(paymentID: model.paymentID, paymentString: model.paymentString, cellIsSelected: false))
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
        let copySelf = self

        switch copySelf.subItems[indexOfRow]{
            case .payment(info: let model):

                copySelf.subItems[indexOfRow] =
                    .payment(info: TestPaymentInfoModel(paymentID: model.paymentID, paymentString: model.paymentString, cellIsSelected: true))
                copySelf.items.accept([SectionOfTestModel(model: .main, items: copySelf.subItems)])

                break
            case .creditCard(info: let model):
                
                copySelf.subItems[indexOfRow] = .creditCard(info: TestCreditCardInfoModel(creditCardNumString: model.creditCardNumString, cardCellIsSelected: true))
                copySelf.items.accept([SectionOfTestModel(model: .main, items: copySelf.subItems)])

                break
            default:
                break
        }
        
    }
}
