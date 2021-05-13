//
//  TableViewController4.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/2/3.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class TableViewController4: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    //負責對象銷毀
    let disposeBag = DisposeBag()

    typealias SectionOfTestModel = SectionModel<TableViewSection,TableViewItem>

    enum TableViewSection {
        case payment(info: TestPaymentInfoModel)
    }

    enum TableViewItem {
        case creditCard(info: TestCreditCardInfoModel)
    }

    private lazy var dataSource = RxTableViewSectionedReloadDataSource<SectionOfTestModel>(configureCell: configureCell)

    private lazy var configureCell: RxTableViewSectionedReloadDataSource<SectionOfTestModel>.ConfigureCell = { [unowned self] (dataSource, tableView, indexPath, item) in
        let copySelf = self
        
        switch item {
//        case .payment(let info):
//            guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectPaymentCell1", for: indexPath) as? SelectPaymentCell else {
//                return UITableViewCell()
//            }
//            cell.paymentLabel.text = info.paymentString
//            cell.selectImageView.image = info.cellIsSelected ? #imageLiteral(resourceName: "check_single"):#imageLiteral(resourceName: "unchecked")
//
//            return cell
            
        case .creditCard(let info):
            guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "creditCardIRowCell", for: indexPath) as? CreditCardItemCell else {
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
    var subSelectItems = TableViewSection.self
    var subRowItems = [TableViewItem]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
//        let dataSource = self.dataSource
//        let items = Observable.just([
//            SectionOfTestModel(model:.payment(info: TestPaymentInfoModel(paymentID: "credit", paymentString: "信用卡", cellIsSelected: false)), items: [
//                    .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "000000000000000")),
//                    .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "111111111111111")),
//                    .creditCard(info: TestCreditCardInfoModel(creditCardNumString: "222222222222222")),
//                ]),
//            SectionModel(model: .payment(info: TestPaymentInfoModel(paymentID: "line", paymentString: "Line", cellIsSelected: false)), items: [
//                ]),
//            SectionModel(model: .payment(info: TestPaymentInfoModel(paymentID: "apple", paymentString: "Apple", cellIsSelected: false)), items: [
//                ]),
//            SectionModel(model: .payment(info: TestPaymentInfoModel(paymentID: "jkos", paymentString: "街口帳戶", cellIsSelected: false)), items: [
//                ])
//            ])
//        items.bind(to: tableView.rx.items(dataSource: dataSource))
//        .disposed(by: disposeBag)

//        items.accept([SectionOfTestModel(model: .payment(info: TestPaymentInfoModel()), items: subRowItems)])

    }

}

extension TableViewController4 :UITableViewDataSource,UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "selectPaymentSectionCell") as! SelectPaymentSectionCell
        return headerCell

    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            
            return 3
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("select")
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = self.tableView.dequeueReusableCell(withIdentifier: "creditCardIRowCell", for: indexPath) as? CreditCardItemCell else {
            return UITableViewCell()
        }
//        cell.cardNumberLabel.text = info.creditCardNumString
//        cell.cardSelectImageView.image = info.cardCellIsSelected ? #imageLiteral(resourceName: "check_line") : nil

        return cell
    }
    
    
}
