
import UIKit
import Firebase
import GoogleSignIn
import GoogleSignInSwift
class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet var tableView: UITableView!
    let data = ["Log out"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell=tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .red
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let actionSheet=UIAlertController()
        actionSheet.addAction(UIAlertAction(title: "Log out", style: .destructive,handler: {[weak self]_ in
            do
            {
                try Auth.auth().signOut()
                let vc=LoginViewController() //renavigating to login page
                let nav = UINavigationController(rootViewController: vc)//creating a navigation view for going to and back to login page keeping the Login page as root view
                nav.modalPresentationStyle = .fullScreen //mode of navigation
                self!.present(nav,animated: true)
            }
            catch
            {
                print("Failed to logout")
            }
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(actionSheet,animated: true)
    }
}
