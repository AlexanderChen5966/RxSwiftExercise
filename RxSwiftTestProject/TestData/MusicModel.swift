//
//  MusicModel.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/9.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import Foundation
//歌曲结构体
struct Music {
    let name: String //歌名
    let singer: String //演唱者
    init(name: String, singer: String) {
        self.name = name
        self.singer = singer
    }
}

//实现 CustomStringConvertible 协议，方便输出调试
extension Music: CustomStringConvertible {
    var description: String {
        return "name：\(name) singer：\(singer)"
    }
}



struct TestPaymentInfoModel {
    var paymentID:String = ""
    var paymentString:String = ""
    var cellIsSelected:Bool = false
}

struct TestCreditCardInfoModel {
//    var creditCardTypeString: String = ""
    var creditCardNumString: String = ""
    var creditCardNumIndex: Int = 0

//    var creditCardIDString: String = ""
    var cardCellIsSelected:Bool = false

}
