//
//  TestCell.swift
//  O2OForUser
//
//  Created by AlexanderChen on 2019/9/17.
//  Copyright © 2019 Sonet. All rights reserved.
//

import UIKit

class SelectPaymentCell: UITableViewCell {

    @IBOutlet weak var selectImageView: UIImageView!
    @IBOutlet weak var paymentLabel: UILabel!

    @IBOutlet weak var paymentImageView: UIImageView!
    var viewModel: TestPaymentInfoModel?{
        didSet{
            paymentLabel.text = viewModel?.paymentString
            selectImageView.image = viewModel!.cellIsSelected ? #imageLiteral(resourceName: "check_single"):#imageLiteral(resourceName: "unchecked")

        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        print("payment select")
    }
}
