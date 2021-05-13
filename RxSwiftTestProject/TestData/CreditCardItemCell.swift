//
//  TestCell1.swift
//  O2OForUser
//
//  Created by AlexanderChen on 2019/9/23.
//  Copyright © 2019 Sonet. All rights reserved.
//

import UIKit
import RxSwift

class CreditCardItemCell: UITableViewCell  {
    
    @IBOutlet weak var cardNameLabel: UILabel!

    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var cardSelectImageView: UIImageView!
    var disposeBag = DisposeBag()

    var viewModel:TestCreditCardInfoModel?
    
    //Cell重用時使用
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

}
