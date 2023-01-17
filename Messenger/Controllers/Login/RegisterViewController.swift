import UIKit
import Firebase
import JGProgressHUD
class RegisterViewController: UIViewController, UITextFieldDelegate {

    private let spinner = JGProgressHUD(style: .dark)
    private let scrollView:UIScrollView =
    {
        let scrollView=UIScrollView()
        scrollView.clipsToBounds=true
        return scrollView
    }()
    
    private let imageView:UIImageView={ //adding an image from the assets
        let imageView=UIImageView()
        imageView.image=UIImage(systemName:"person")
        imageView.tintColor = .gray
        imageView.layer.masksToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.gray.cgColor
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let firstNameField:UITextField = //adding a text field for typing the first name
    {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue //when the user clicks enter the cursor moves to the next textfield
        
        //setting the design of the field
        field.layer.cornerRadius=12
        field.layer.borderWidth=3
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "First Name"
        field.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastNameField:UITextField = //adding a text field for typing the last name
    {
        let field=UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue //when the user clicks enter the cursor moves to the next textfield
        
        //setting the design of the field
        field.layer.cornerRadius=12
        field.layer.borderWidth=3
        field.layer.borderColor=UIColor.lightGray.cgColor
        field.placeholder = "Last Name"
        field.leftView=UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
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
    
    private let registerButton:UIButton =
    {
        let login = UIButton()
        login.setTitle("Register", for: .normal)
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
        gradientLayer.colors = [UIColor.yellow.cgColor,UIColor.red.cgColor]
        
        view.layer.addSublayer(gradientLayer)*/
        
        navigationItem.rightBarButtonItem=UIBarButtonItem(title: "Register", style: .done, target: self, action: #selector(didTapRegister)) //setting the navigation button on the right side of the navigation bar
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside) //setting the task of login button
        
        emailField.delegate = self
        passwordField.delegate = self
        
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
        imageView.isUserInteractionEnabled=true //allowing the user to tap on the image view
        scrollView.isUserInteractionEnabled=true
        let gesture=UITapGestureRecognizer(target: self, action: #selector(didTapProfile))
        imageView.addGestureRecognizer(gesture)
        
    }
    @objc func didTapProfile()
    {
        print("change profile picture")
        presentPhotoActionSheet()
        
    }
    
    override func viewDidLayoutSubviews() { //just an inbuilt function that shows the view
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = view.width/3
        imageView.frame=CGRect(x:size+15, y: 100, width: size-20, height:size-20)
        imageView.layer.cornerRadius = imageView.width/2.0
        firstNameField.frame=CGRect(x:30, y: imageView.bottom + 30, width: scrollView.width-60,height: 52)
        lastNameField.frame=CGRect(x:30, y: firstNameField.bottom + 30, width: scrollView.width-60,height: 52)
        emailField.frame=CGRect(x:30, y: lastNameField.bottom + 30, width: scrollView.width-60,height: 52)
        passwordField.frame=CGRect(x:30, y: emailField.bottom + 30, width: scrollView.width-60,height: 52)
        registerButton.frame=CGRect(x:size+30, y: passwordField.bottom + 40, width: 70,height: 50)
        
    }
    
    @objc private func didTapRegister()
    {
        let vc=RegisterViewController()
        vc.title = "Create account"
        navigationController?.pushViewController(vc, animated: true)//animating the navigation from login page to register page
    }
    @objc private func registerButtonTapped() //validation of the credentials
    {
        guard let email = emailField.text,let password = passwordField.text,let firstName = firstNameField.text,let lastName = lastNameField.text, !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !lastName.isEmpty else{
            alertUserLoginError()
            return
        }
        spinner.show(in: view)
        DatabaseManager.shared.userExists(with: email, completion: {[weak self]exists in
            guard let strongSelf=self else
            {
                return
            }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)
            }
            guard !exists else
            {
                //user exists already
                self!.alertUserLoginError(msg:"User already exists")
                return
            }
            //user does not exists. Hence creating a new user.
        Auth.auth().createUser(withEmail: email, password: password,completion: {[weak self] result,error in
            guard let strongSelf = self else
            {
                return
            }
            if error != nil
            {
                print(error!.localizedDescription)
            }
            else
            {
                let user = result?.user
                print("Registered user \(String(describing: user))")
                strongSelf.navigationController?.dismiss(animated: true)
            }
         })
            let chatUser = ChatAppUser(firstName: firstName, lastName: lastName, emailAddress: email)
            DatabaseManager.shared.insertUser(with:chatUser,completion: {success in
                if success
                {
                    //upload image
                    guard let image = self?.imageView.image,let data=image.pngData() else
                    {
                        return
                    }
                    let fileName=chatUser.profilePicFileName
                    StorageManager.shared.uploadProfilePic(with: data, fileName: fileName, completion: {result in
                        switch result
                        {
                        case .success(let downloadUrl):
                            UserDefaults.standard.set(downloadUrl, forKey: "profile_pic_url")
                            print(downloadUrl)
                        case .failure(let error):
                            print("\(error)")
                        }
                    })
                }
            }) //calling insertUser from Database Manager
        })
    }
    
    func alertUserLoginError(msg:String="Please enter all information to create a new account.") //setting alert message for the user
    {
        let alert=UIAlertController(title: "Oops!", message: msg, preferredStyle: .alert) //setting an alert message when the conditions are not met by the user
        present(alert,animated: true)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel)) //giving a dismiss option for the user
    }
}

//if the user types the password and clicks enter then loginButtonTapped is automatically called without explicitly pressing the button
extension RegisterViewController:UITextViewDelegate,UINavigationControllerDelegate
{
    func textFieldShouldReturn(textField:UITextField)->Bool
    {
        if textField == emailField
        {
            passwordField.becomeFirstResponder()//checkout what this function does
        }
        else if textField == passwordField
        {
            registerButtonTapped()
        }
        return true
    }
}

extension RegisterViewController:UIImagePickerControllerDelegate
{
    func presentPhotoActionSheet()
    {
        let actionSheet = UIAlertController(title: "Profile Picture", message: "How would you like to select a picture?", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default,handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default,handler: {[weak self] _ in
            self?.presentPhotoPicker()
        }))
        present(actionSheet,animated: true)
    }
    
    func presentCamera()
    {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    func presentPhotoPicker() //creating a function for the user to choose photo from library and using the function in the actionSheet when we click Choose photo
    {
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc,animated: true)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        let selectedImage = info[UIImagePickerController.InfoKey.editedImage]
        self.imageView.image = (selectedImage as! UIImage) //setting the image we choose in the photo library as the profile picture
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
