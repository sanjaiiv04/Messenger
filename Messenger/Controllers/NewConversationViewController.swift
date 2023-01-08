//
//  NewConversationViewController.swift
//  Messenger
//
//  Created by sanjaii vijayakumar on 1/8/23.
//

import UIKit

class NewConversationViewController: UIViewController {
    private let searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Conversation"
        return bar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar //search bar at top
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder() //invokes keyboard when searchBar opens
    }
    @objc private func dismissSelf()
    {
        dismiss(animated: true)
    }
    
    private let tableView:UITableView={
        let table = UITableView()
        table.isHidden=true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noResultLabel:UILabel={
        let label=UILabel()
        label.isHidden=true
        label.text="No results"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21,weight: .medium)
        return label
    }()
}
extension NewConversationViewController:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
    }
}
