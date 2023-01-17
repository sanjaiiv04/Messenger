
import UIKit
import JGProgressHUD
class NewConversationViewController: UIViewController {
    private let spinner = JGProgressHUD(style: .dark)
    
    private var users=[[String:String]]()//array of users pulled from firebase for searching purposes
    
    private var results=[[String:String]]()
    private var hasFetched = false
    
    private let searchBar:UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "Search Conversation"
        return bar
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(noResultLabel)
        view.addSubview(tableView)
        tableView.delegate=self
        tableView.dataSource=self
        
        searchBar.delegate = self
        view.backgroundColor = .white
        navigationController?.navigationBar.topItem?.titleView = searchBar //search bar at top
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done, target: self, action: #selector(dismissSelf))
        searchBar.becomeFirstResponder() //invokes keyboard when searchBar opens
    }
    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.width/4, y: (view.height-200)/2, width: view.width/2, height: 200)
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

extension NewConversationViewController:UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = results[indexPath.row]["name"]
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //start a conversation
    }
}
extension NewConversationViewController:UISearchBarDelegate
{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text=searchBar.text, !text.replacingOccurrences(of: " ", with: "").isEmpty else
        {
            return
        }
        results.removeAll()//removing the results after clicking search
        spinner.show(in: view)
        self.searchUsers(query: text)
    }
    
    func searchUsers(query:String)
    {
        if hasFetched
        {
            filterUsers(with: query)
        }
        else
        {
            DatabaseManager.shared.getAllUsers(completion: {[weak self]result in
                switch result{
                case .success(let usersCollection):
                    self?.hasFetched=true
                    self?.users=usersCollection
                    self?.filterUsers(with: query)
                case .failure(let error):
                    print("Failed to get users:\(error)")
                }
            })
        }
    }
    
    func filterUsers(with term:String)
    {
        guard hasFetched else
        {
            return
        }
        self.spinner.dismiss(animated: true)
        let results:[[String:String]]=self.users.filter({
            guard let name = $0["name"]?.lowercased() as? String else
            {
                return false
            }
            
            return name.hasPrefix(term.lowercased())
        })
        
        self.results = results
        updateUI()
        
    }
    
    func updateUI()
    {
        if results.isEmpty
        {
            self.noResultLabel.isHidden=false
            self.tableView.isHidden=true
        }
        else
        {
            self.noResultLabel.isHidden=true
            self.tableView.isHidden=false
            self.tableView.reloadData()
        }
    }
}
