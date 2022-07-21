//
//  ViewController.swift
//  RxSwift+MVVM
//
//  Created by iamchiwon on 05/08/2019.
//  Copyright © 2019 iamchiwon. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MenuViewController: UIViewController {
    // MARK: - Life Cycle
    let cellId = "MenuItemTableViewCell"

    let viewModel = MenuListViewModel() // viewmodel에서 데이터 받아서 사용
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        self.tableView.dataSource = nil
        super.viewDidLoad()
        
        viewModel.menuObservable
            .bind(to: tableView.rx.items(cellIdentifier: cellId, cellType: MenuItemTableViewCell.self)) {index,item,cell in
                cell.title.text = item.name
                cell.price.text = "\(item.price)"
                cell.count.text = "\(item.count)"
                
                cell.onChange = { [weak self]increase in
                    self? .viewModel.changeCount(item: item,increase: increase)
                }
            }
            .disposed(by: disposeBag)
            
        
        viewModel.itemsCount
            .map { "\($0)"} // 문자열로 변환
            .observeOn(MainScheduler.instance)
            .bind(to: self.itemCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        //Rx로 처리 - 값이 변하면 UI 자동으로 바꿔줘
        viewModel.totalPrice
            .map { $0.currencyKR() }
            .observeOn(MainScheduler.instance)
            .bind(to: self.totalPrice.rx.text)
            .disposed(by: disposeBag)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let identifier = segue.identifier ?? ""
        if identifier == "OrderViewController",
            let orderVC = segue.destination as? OrderViewController {
            // TODO: pass selected menus
        }
    }
    
    func showAlert(_ title: String, _ message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertVC, animated: true, completion: nil)
    }

    // MARK: - InterfaceBuilder Links

    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var itemCountLabel: UILabel!
    @IBOutlet var totalPrice: UILabel!

    @IBAction func onClear() {
        viewModel.clearAllItemSelections()
    }

    @IBAction func onOrder(_ sender: UIButton) {
        // TODO: no selection
        // showAlert("Order Fail", "No Orders")
//        performSegue(withIdentifier: "OrderViewController", sender: nil)
//        viewModel.menuObservable.onNext([
//            Menu(name: "changed",price: Int.random(in: 100...1000),count: Int.random(in: 0...3)),
//            Menu(name: "changed",price: Int.random(in: 100...1000),count: Int.random(in: 0...3)),
//            Menu(name: "changed",price: Int.random(in: 100...1000),count: Int.random(in: 0...3))
//        ])
    }
}

//extension MenuViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.menuObservable // 메뉴의 개수 만큼
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTableViewCell") as! MenuItemTableViewCell
//
//        let menu = viewModel.menus[indexPath.row]
//        cell.title.text = menu.name
//        cell.price.text = "\(menu.price)"
//        cell.count.text = "\(menu.count)"
//
//        return cell
//    }
//}
