//
//  MusicViewModel.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/9.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import Foundation
import RxSwift
import RxDataSources

//歌曲列表數據源
//傳統式編程
struct MusicListViewModel {
    let data = [
        Music(name: "無條件", singer: "陳奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "以前的我", singer: "陳潔儀"),
        Music(name: "忘詞", singer: "五月天"),
    ]
}

//響應式編程
struct MusicListViewRxModel {
    
    let rxData = Observable.just([
        Music(name: "無條件", singer: "陳奕迅"),
        Music(name: "你曾是少年", singer: "S.H.E"),
        Music(name: "以前的我", singer: "陳潔儀"),
        Music(name: "忘詞", singer: "五月天"),
    ])
}

typealias SectionOfTestModel = SectionModel<TableViewSection,TableViewItem>

enum TableViewSection {
    case main
}

enum TableViewItem {
    case payment(info: TestPaymentInfoModel)
    case creditCard(info: TestCreditCardInfoModel)
}



struct TestCardInfoViewModel {
    let items = PublishSubject<[SectionOfTestModel]>()
    var subItems = [TableViewItem]()

    mutating func getInformation() {
        
        //server call
        //database query
        
        subItems = ([
            .payment(info: TestPaymentInfoModel(paymentID: "credit", paymentString: "信用卡", cellIsSelected: false)),
            .payment(info: TestPaymentInfoModel(paymentID: "line", paymentString: "Line", cellIsSelected: false)),
            .payment(info: TestPaymentInfoModel(paymentID: "apple", paymentString: "Apple", cellIsSelected: false)),
            .payment(info: TestPaymentInfoModel(paymentID: "jkos", paymentString: "街口帳戶", cellIsSelected: false)),

        ])
        
        items.onNext([SectionOfTestModel(model: .main, items: subItems)])
    }

    mutating func getCellInformation(indexPath:Int) -> TableViewItem {
        return subItems[indexPath]
    }
    
    mutating func getCellImageChange(indexPath:Int) -> TableViewItem {
        subItems[indexPath] = .payment(info: TestPaymentInfoModel(paymentID: "jkos", paymentString: "街口帳戶", cellIsSelected: false))
        return subItems[indexPath]
    }

}
