//
//  SignUPVC.swift
//  Zeedup
//
//  Created by Farhana Khan on 16/05/21.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseDatabase
class SignUPVC: UIViewController {
    var ref: DatabaseReference!
    
    @IBOutlet weak var numberTF: Custom!
    @IBOutlet weak var passwordTF: Custom!
    @IBOutlet weak var nameTF: Custom!
    @IBOutlet weak var lastNameTf: Custom!
    @IBOutlet weak var emailTF: Custom!
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.isToolbarHidden = true
//    }
    func HomeScreen()  {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func ValidateFields() -> String? {
        
        //Check that all fields are filled in
        if nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || lastNameTf.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || emailTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || numberTF.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            return "Please fill in all fields"
        }
        //check if password is secure
        let cleanedPassword = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if isPasswordValid(cleanedPassword) == false {
            return "Please make sure your password is atleast 8 charcter,contains special character and a number."
        }
        return nil
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print()
        self.navigationController?.navigationBar.isHidden = false
        let leftBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        customEmailTextfield()
    }
    @objc func back() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func customEmailTextfield() {
        let nameView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let lastView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let passView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let mailView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        
        mailView.backgroundColor = UIColor.clear
        
        let line = UIView(frame: CGRect(x: 0, y: 0, width: 2, height: 40))
        
        let mailV = UIButton(frame: CGRect(x: 10, y: 0, width: 30, height: 20))
        let nameV = UIButton(frame: CGRect(x: 10, y: 0, width: 30, height: 20))
        let LastnameV = UIButton(frame: CGRect(x: 10, y: 0, width: 30, height: 20))
        let passV = UIButton(frame: CGRect(x: 10, y: 0, width: 30, height: 20))
        
        nameV.setImage(UIImage(named: "user.png"), for: .normal)
        nameView.addSubview(nameV)
        nameView.addSubview(line)
        nameTF.leftViewMode = .always
        nameTF.leftView = nameV
        
        LastnameV.setImage(UIImage(named: "user.png"), for: .normal)
        lastView.addSubview(LastnameV)
        lastView.addSubview(line)
        lastNameTf.leftViewMode = .always
        lastNameTf.leftView = LastnameV
        
        mailV.setImage(UIImage(named: "mail.png"), for: .normal)
        mailView.addSubview(mailV)
        mailView.addSubview(line)
        emailTF.leftViewMode = .always
        emailTF.leftView = mailV
        
        passV.setImage(UIImage(named: "lock.png"), for: .normal)
        passView.addSubview(passV)
        passView.addSubview(line)
        passwordTF.leftViewMode = .always
        passwordTF.leftView = passV
    }
    func showErr(msg : String){
        let alert = UIAlertController(title: "OOPS!", message: "\(msg)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signUP(_ sender: UIButton) {
        let error = ValidateFields()
        if error != nil {
            
            //There's something wrong with the fields, show error message
            showErr(msg: error!)
        }
        else {
            
            //create clean version of data
            let firstName = nameTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTf.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let number = numberTF.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //create the user
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                if  err != nil {
                    //There was an error creating user
                    self.showErr(msg: "Error Creating user")
                }
                else {
                    
                let ref = Database.database().reference(fromURL: "https://zeedup-58e0a-default-rtdb.asia-southeast1.firebasedatabase.app/") //Enter your firebase url here also in GoogleService.plist
                                let usersReference = ref.child("users").child(result!.user.uid)
                    let values = ["firstName":firstName, "lastName": lastName,"email":email,"password":password,"number":number]
                                usersReference.updateChildValues(values, withCompletionBlock: { (err,ref) in
                                    if  err != nil {
                                        print(err!)
                                        self.showErr(msg: "Error saving user data")
                                    }
                                })
                            }
                            
                            return
                    }
        }
                            self.HomeScreen()
    }
    }
func isPasswordValid(_ password : String) -> Bool{
    let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[$@$#!%*?&])[A-Za-z\\d$@$#!%*?&]{8,}")
    return passwordTest.evaluate(with: password)
}



