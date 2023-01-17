
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
        tableView.tableHeaderView = createTableHeader()
        // Do any additional setup after loading the view.
    }
    func createTableHeader()->UIView?
    {
        guard let email=UserDefaults.standard.value(forKey: "email") as? String else
        {
            return nil
        }
        let safeEmail=DatabaseManager.safeEmail(emailAddress: email)
        let fileName = safeEmail+"_profile_picture.png"
        let path = "images/"+fileName
        
        let headerView = UIView(frame:CGRect(x: 0, y: 0, width: self.view.width, height: 300))
        headerView.backgroundColor = .white
        let imageView = UIImageView(frame: CGRect(x: (headerView.width-150)/2, y: 75, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .white
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.layer.borderWidth = 3
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius=imageView.width/2
        headerView.addSubview(imageView)
        StorageManager.shared.downloadURL(for: path, completion: {[weak self]result in
            switch result{
            case .success(let url):
                self?.downloadImage(imageView: imageView, url: url)
            case .failure(let error):
                print("Failed to download url:\(error)")
            }
        })
        return headerView
        
    }
    func downloadImage(imageView:UIImageView,url:URL)
    {
        URLSession.shared.dataTask(with: url, completionHandler: {data,_,error in
            guard let data=data,error==nil else
            {
                return
            }
            DispatchQueue.main.async {
                let image=UIImage(data:data)
                imageView.image = image
            }
        }).resume()
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
