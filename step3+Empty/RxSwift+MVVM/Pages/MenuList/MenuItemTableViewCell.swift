//
//  MenuItemTableViewCell.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 07/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit

class MenuItemTableViewCell: UITableViewCell {
    
    var viewModel : MenuListViewModel!
    
    @IBOutlet var title: UILabel! //메뉴 이름
    @IBOutlet var count: UILabel! //메뉴 선택 개수
    @IBOutlet var price: UILabel! // 메뉴 가격
    
    var onChange: ((Int) -> Void)?

    @IBAction func onIncreaseCount() {
        onChange?(+1)
    }

    @IBAction func onDecreaseCount() {
        onChange?(-1)
    }
}
