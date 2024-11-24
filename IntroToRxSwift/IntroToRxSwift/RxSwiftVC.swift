//
//  RxSwiftVC.swift
//  IntroToRxSwift
//
//  Created by Apple on 24/11/24.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

struct Product1 {
    var imageName : String
    var title : String
}

struct ProductViewModel1{
    var items = PublishSubject<[Product1]>()

    func fetchItems()  {
        let products = [
            Product1(imageName: "house", title: "Home"),
            Product1(imageName: "gear", title: "Setting"),
            Product1(imageName: "person.circle", title: "Profile"),
            Product1(imageName: "airplane", title: "Flights"),
            Product1(imageName: "bell", title: "Activicty")
        ]

        items.onNext(products)
        items.onCompleted()
    }

}
class RxSwiftVC: UIViewController {

    private let tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()


    private var viewModel = ProductViewModel1()
    private var bag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Add tableView to the view hierarchy
        view.addSubview(tableView)
        tableView.frame = view.bounds // Set the tableView's frame to match the view's bounds
        bindTableData()

    }


    func bindTableData() {
        //Bind items to table

        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "cell", cellType: UITableViewCell.self)){row,model,cell in

            cell.textLabel?.text = model.title
            cell.imageView?.image = UIImage(systemName: model.imageName)
        }.disposed(by: bag)

        //Bind a model slected handler
        tableView.rx.modelSelected(Product.self).bind{ product in
            print(product.title)
        }.disposed(by: bag)
        //fetch items
        viewModel.fetchItems()
    }
}
