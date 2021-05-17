//
//  ViewController.swift
//  Zeedup
//
//  Created by Farhana Khan on 16/05/21.
//

import UIKit
import Firebase
import FirebaseAuth
class LoginVC: UIViewController {

    var email = String()
    var pass = String()
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        ifUserIsLoggedCheck()
        customPasswordTextfield()
        customEmailTextfield()
    }
    func ifUserIsLoggedCheck(){
        if Auth.auth().currentUser?.uid == nil{
            logout()
        }else{
            let vc = storyboard?.instantiateViewController(withIdentifier: "UserDataVC") as! UserDataVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
        }catch let err{
            print(err)
        }
    }
    
    func customEmailTextfield() {
        let mobV = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mobV.backgroundColor = UIColor.clear
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 40))
        let mailV = UIButton(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        
        mailV.setImage(UIImage(named: "mail.png"), for: .normal)
        mobV.addSubview(mailV)
        mobV.addSubview(line)
        
        emailTextField.leftViewMode = .always
        emailTextField.leftView = mobV
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    func customPasswordTextfield() {
        let mobV = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        mobV.backgroundColor = UIColor.clear
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 40))
        let btn = UIButton(frame: CGRect(x: 10, y: 5, width: 30, height: 30))
        
        btn.setImage(UIImage(named: "lock.png"), for: .normal)
        
        mobV.addSubview(btn)
        mobV.addSubview(line)
        
        passwordTextField.leftViewMode = .always
        passwordTextField.leftView = mobV
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
   
    @IBAction func loginBtn(_ sender: UIButton) {
        let error = validateFields()
        if error != nil{
            showErr(msg: error!)
        }
        else{
            
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        Auth.auth().signIn(withEmail: email, password: password) { (result, err) in
            if  err != nil {
                //could'nt Sign in
                let alert = UIAlertController(title: "OOPS!", message: "Incorrect username/password", preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)
                self.present(alert, animated: true, completion: nil)
            }
            else {
                self.emailTextField.text = ""
                self.passwordTextField.text = ""
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "UserDataVC") as! UserDataVC
                self.navigationController?.pushViewController(vc, animated: true)
    }
        }
    }
            func handleLogout() {
                do{
                    try Auth.auth().signOut()
                }catch let err{
                    print(err)
                }
            }
            func ifUserIsLoggedCheck(){
                if Auth.auth().currentUser?.uid == nil{
                    handleLogout()
                }
                else{
                    let vc = storyboard?.instantiateViewController(withIdentifier: "UserDataVC") as! UserDataVC
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
    }
    @IBAction func signUpBtn(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SignUPVC") as! SignUPVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
        //MARK:- Validation of fields
        func validateFields() -> String? {
            
            if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
                passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                
                return "Please fill in all fields."
            }
            
            //Check if the email is correct
            let cleanEmail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if isValidEmail(cleanEmail) == false{

                return "Something is wrong!! Make sure you've enter correct Email address."
            }
            
            //Check if the password is secure
            let cleanPass = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            if isPasswordValid(cleanPass) == false{
                
                return "Something is wrong!! Make sure you've enter correct password."
            }
            return nil
        }
        
        
        func isPasswordValid(_ password : String) -> Bool{
            
            let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
            return passwordTest.evaluate(with: password)
        }
        
        func isValidEmail(_ email: String) -> Bool {
            
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
        func showErr(msg: String){
            
            let alert = UIAlertController(title: "", message: "", preferredStyle: .actionSheet)
            let titleAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.black]
            let titleString = NSAttributedString(string: "\(msg)", attributes: titleAttributes)
            alert.setValue(titleString, forKey: "attributedTitle")
            
            let dismiss = UIAlertAction(title: "Dismiss", style: .destructive, handler: nil)
            alert.addAction(dismiss)
            self.present(alert, animated: true, completion: nil)
        }
}
