//
//  RxInnerButtonCell.swift
//  RxSwiftTestProject
//
//  Created by AlexanderChen on 2020/1/30.
//  Copyright © 2020 AlexanderChen. All rights reserved.
//

import UIKit
import RxSwift

class RxInnerButtonCell: UITableViewCell {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    
    var disposeBag = DisposeBag()
    
    //Cell重用時使用
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
