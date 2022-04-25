//
//  ViewController.swift
//  IntroToRxSwift
//
//  Created by Mac on 2022/04/24.
//

import UIKit
import RxSwift
import RxCocoa

//모델
struct Product {
    let imageName: String
    let title: String
}

//뷰모델
struct ProductViewModel {
    var items = PublishSubject<[Product]>()
    
    func fatchItems(){
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Settings"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        
        items.onNext(products)
        items.onCompleted()
    }
}

class ViewController: UIViewController {

    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    
    private var bag = DisposeBag()//RxSwift에서 나오는 개념
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        bindTableData()
        
    }

    func bindTableData(){
        //Bind items to table
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){
            row, model, cell in
            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)//*dispose(사전적 정의:(무엇을 없애기 위한)처리))
        
        //Bind a model selected handler -> 전통적인 delegate를 사용하지 않음
        tableView.rx.modelSelected(Product.self).bind { product in
            print(product.title)
        }.disposed(by: bag)
        
        //fatch items
        viewModel.fatchItems()
    }

}

