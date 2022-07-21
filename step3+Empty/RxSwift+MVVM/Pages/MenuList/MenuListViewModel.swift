//
//  MenuListViewModel.swift
//  RxSwift+MVVM
//
//  Created by SangWoo's MacBook on 2022/07/21.
//  Copyright © 2022 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift

class MenuListViewModel {
    // MVVM ( Model View ViewModel)
    // 데이터를 View(ios에선 controller로 대부분)에서 처리하지 않고 ViewModel에 두고 Model과 View를 중계
    //사용시 MenuListViewModel View(controller)에서 인스턴스를 생성하여 사용
    
    lazy var menuObservable = BehaviorSubject<[Menu]>(value: [])
    
    lazy var itemsCount = menuObservable.map {menus in
        menus.map { $0.count }.reduce(0, +)
    }
    lazy var totalPrice = menuObservable.map {menus in
        menus.map { $0.price * $0.count }.reduce(0, +)
    }
    
    init() {
        let menus: [Menu] = [ // Model <-> ViewModel<-> View
            Menu(id: 0, name: "튀김1", price: 100, count: 0),
            Menu(id: 1, name: "튀김2", price: 100, count: 0),
            Menu(id: 2, name: "튀김3", price: 100, count: 0),
            Menu(id: 3, name: "튀김4", price: 100, count: 0)
        ]
        
        menuObservable.onNext(menus)
    }
    
    //clear버튼 클릭시 개수 초기화
    func clearAllItemSelections() {
        _ = menuObservable
            .map { menus in
                return menus.map { m in
                    Menu(id: m.id, name: m.name, price: m.price, count:0)
                }
        }
        .take(1) // 1개의 스트림만 생성될 수 있게 처리 해주기
        .subscribe(onNext: {
            self.menuObservable.onNext($0)
        })
    }
    
    func changeCount(item: Menu, increase: Int){
        _ = menuObservable
            .map { menus in
                menus.map { m in
                    if m.name == item.name {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: m.count + increase)
                    }else {
                        return Menu(id: m.id,
                                    name: m.name,
                                    price: m.price,
                                    count: m.count)
                    }
                    
                }
        }
        .take(1) // 1개의 스트림만 생성될 수 있게 처리 해주기
        .subscribe(onNext: {
            self.menuObservable.onNext($0)
        })
    }
}
