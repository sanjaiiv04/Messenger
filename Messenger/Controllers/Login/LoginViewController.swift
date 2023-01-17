import UIKit
import Firebase
import GoogleSignIn
import JGProgressHUD
class LoginViewController: UIViewController, UITextFieldDelegate {
    
    private let spinner = JGProgressHUD(style: .dark)
    private let scrollView:UIScrollView =
    {
        let scrollView=UIScrollView()
        scrollView.clipsToBounds=true
        return scrollView
    }()
    
    private let imageView:UIImageView={ //adding an image from the assets
        let imageView=UIImageView()
        imageView.image=UIImage(named: "iTunesArtwork")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let emailField:UITextField = //adding a text field for typing the email address
    {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue //when the user clicks enter the cursor moves to the next textfield
        
        //setting the design of the field
        field.layer.cornerRadius=12
        field.layer.borderWidth=3
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "Email address"
        field.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField:UITextField =
    {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done//when the user clicks enter they are automatically logged in
        
        //setting the design of the field
        field.layer.cornerRadius=12
        field.layer.borderWidth=3
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "Password"
        field.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true //password is hidden
        return field
    }()
    
    private let LoginButton:UIButton =
    {
        let login = UIButton()
        login.setTitle("Login", for: .normal)
        login.backgroundColor = .cyan
        login.setTitleColor(.darkGray, for: .normal)
        login.layer.cornerRadius=18
        return login
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Log In"
        view.backgroundColor = .white
        /*let gradientLayer = CAGradientLayer()
         gradientLayer.frame = view.bounds
         gradientLayer.colors = [UIColor.purple.cgColor,UIColor.systemPink.cgColor]
         
         view.layer.addSublayer(gradientLayer)*/
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister)) //setting the navigation button on the right side of the navigation bar to navigate from login page to resgister page
        
        LoginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside) //setting the task of login button
        
        emailField.delegate = self //check what it is
        passwordField.delegate = self //check what it is
        
        //adding the views on the loginView
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(LoginButton)
        
    }
    
    override func viewDidLayoutSubviews() { //just an inbuilt function that shows the view
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = view.width/3
        imageView.frame=CGRect(x:size+15, y: 100, width: size-30, height:size-30)
        emailField.frame=CGRect(x:30, y: imageView.bottom + 30, width: scrollView.width-60,height: 52)
        passwordField.frame=CGRect(x:30, y: emailField.bottom + 20, width: scrollView.width-60,height: 52)
        LoginButton.frame=CGRect(x:30, y: passwordField.bottom + 40, width:scrollView.width-60,height: 52)
        
    }
    
    @objc private func didTapRegister() //when register button is tapped move to register page
    {
        let vc=RegisterViewController()
        vc.title = "Create account"
        navigationController?.pushViewController(vc, animated: true)//animating the navigation from login page to register page
    }
    @objc private func loginButtonTapped() //validation of the credentials
    {
        
        //if the emailfield and userfield is not filled or if the password is not atleast 6 characters long we call the alert message
        guard let email = emailField.text, let password = passwordField.text,!email.isEmpty,!password.isEmpty else{
            alertUserLoginError()
            return
        }
        
        
        spinner.show(in: view)
        //firebase login
        Auth.auth().signIn(withEmail: email, password: password,completion: {[weak self]result,error in
            guard let strongSelf=self else
            {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)//spinner animation
            }
            if error != nil
            {
                print(error!.localizedDescription)
            }
            else
            {
                let user = result?.user
                UserDefaults.standard.set(email, forKey: "email")//caching the email when the user logs in
                print("Logged in \(String(describing: user))")
                strongSelf.navigationController?.dismiss(animated: true)
            }
        })
    }
    
    func alertUserLoginError() //setting alert message for the user
    {
        let alert=UIAlertController(title: "Oops!", message: "Please enter all information to login", preferredStyle: .alert) //setting an alert message when the conditions are not met by the user
        present(alert,animated: true)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel)) //giving a dismiss option for the user
    }
    
}
//if the user types the password and clicks enter then loginButtonTapped is automatically called without explicitly pressing the button
extension LoginViewController:UITextViewDelegate
{
    func textFieldShouldReturn(textField:UITextField)->Bool
    {
        if textField == emailField
        {
            passwordField.becomeFirstResponder()//checkout what this function does
        }
        else if textField == passwordField
        {
            loginButtonTapped()
        }
        return true
    }
}
