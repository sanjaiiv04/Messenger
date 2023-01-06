import UIKit
import Firebase
class ConversationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .gray
        //DatabaseManager.shared.test()  - testing if a child is created in realtime in firebase
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

}

