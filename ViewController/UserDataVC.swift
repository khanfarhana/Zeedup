//
//  UserDataVC.swift
//  WeatherApp
//
//  Created by Farhana Khan on 17/05/21.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import Firebase
class UserDataVC: UIViewController {
    var ref: DatabaseReference?
    var userData = [userValue]()
    
    @IBOutlet weak var TV: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: .plain, target: self , action: #selector(handleLogout))
        TV.delegate = self
        TV.dataSource = self
        
        fireRef()
        ifUserIsLoggedCheck()
    }
    
    @objc func handleLogout() {
        logout()
        let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        navigationController?.pushViewController(vc, animated: true)
    }
    func fireRef(){
        
        //Set firebase reference
        ref = Database.database().reference().child("users")
        ref?.observe(.childAdded, with: { [weak self] (snapshot) in
            let key = snapshot.key
            guard let value = snapshot.value as? [String : Any] else { return }
            if let Fname = value["firstName"] as? String, let Lname = value["lastName"]  as? String, let email = value["email"]  as? String, let number = value["number"] as? String, let password = value["password"] as? String {
                let myUser = userValue( id: key,firstName: Fname, lastName: Lname , password: password, email: email , number: number)
                self?.userData.append(myUser)
                self?.TV.reloadData()
            }
        })
    }
    
    func ifUserIsLoggedCheck(){
        if Auth.auth().currentUser?.uid == nil{
            logout()
        }
        else{
            let uid = Auth.auth().currentUser?.uid
            Database.database().reference().child("users").child(uid!).observe(.value) { [weak self] (snapshot) in
                if let value = snapshot.value as? [String : Any]{
                    self?.navigationItem.title = "Hello \(value["firstName"]  as? String ?? "") \(value["lastName"]  as? String ?? "")"
                }
            }
        }
    }
    
    @objc func logout(){
        do{
            try Auth.auth().signOut()
        }catch let err{
            print(err)
        }
    }

}


extension UserDataVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(userData.count)

        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! CustomTVC
        let demo = userData[indexPath.row]
        cell.nameLb.text = "\(demo.firstName) \(demo.lastName)"
        cell.emailLb.text = demo.email
        cell.number.text = demo.number
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    
}
