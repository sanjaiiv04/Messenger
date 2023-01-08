import UIKit
import Firebase
import JGProgressHUD
class ConversationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.isHidden = true //when there is no convo for the user then dont show the table cells.
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    private let noConvoLabel:UILabel={
        let label=UILabel()
        label.text = "No conversations"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden=true
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        view.addSubview(tableView)
        view.addSubview(noConvoLabel)
        setupTable()
        setUpConvo()
        
        //DatabaseManager.shared.test()  - testing if a child is created in realtime in firebase
    }
    @objc private func didTapComposeButton()
    {
        let vc = NewConversationViewController()
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC,animated:true)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        validateAuth()
    }
    private func validateAuth()
    {
        if Auth.auth().currentUser == nil //checking if the user is logged in. If the user is not logged in they are navigated to login page
        {
            let vc=LoginViewController() //renavigating to login page
            let nav = UINavigationController(rootViewController: vc)//creating a navigation view for going to and back to login page keeping the Login page as root view
            nav.modalPresentationStyle = .fullScreen //mode of navigation
            present(nav,animated: true) //providing animation to the navigation between loaded page and login page
        }
    }
    
    private func setupTable()
    {
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    func setUpConvo()
    {
        tableView.isHidden = false
    }
}
extension ConversationViewController
{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for:indexPath)
        cell.textLabel?.text = "Sanjaii"
        cell.accessoryType = .disclosureIndicator //the arrow at the end of the cell.
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "Sanjaii"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

