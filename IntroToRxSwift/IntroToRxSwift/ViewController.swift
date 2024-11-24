//
//  ViewController.swift
//  IntroToRxSwift
//
//  Created by Apple on 23/11/24.


import UIKit
import Combine

struct Product {
    var imageName: String
    var title: String
}

class ProductViewModel {
    @Published var items: [Product] = []
    
    func fetchItems() {
        let products = [
            Product(imageName: "house", title: "Home"),
            Product(imageName: "gear", title: "Setting"),
            Product(imageName: "person.circle", title: "Profile"),
            Product(imageName: "airplane", title: "Flights"),
            Product(imageName: "bell", title: "Activity")
        ]
        
        items = products
    }
    
    func addItem() {
        items.append(Product(imageName: "bell", title: "\(Date())"))
    }
}

class ViewController: UIViewController {
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private var viewModel = ProductViewModel()
    private var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Add tableView to the view hierarchy
        view.addSubview(tableView)
        tableView.frame = view.bounds // Set the tableView's frame to match the view's bounds
        
        bindTableData()
    }
    
    func bindTableData() {
        // Bind items to table
        viewModel.$items
            .receive(on: RunLoop.main)
            .sink { [weak self] products in
                guard let self = self else { return }
                self.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Set up tableView data source
        tableView.dataSource = self
        
        // Handle selection
        tableView.delegate = self
        
        // Fetch items
        viewModel.fetchItems()
    }
}

// MARK: - UITableViewDataSource & UITableViewDelegate
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let product = viewModel.items[indexPath.row]
        cell.textLabel?.text = product.title
        cell.imageView?.image = UIImage(systemName: product.imageName)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let product = viewModel.items[indexPath.row]
        print(product.title)
        
        viewModel.addItem()
    }
}

