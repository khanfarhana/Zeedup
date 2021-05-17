//
//  AViewController.swift
//  Zeedup
//
//  Created by Farhana Khan on 17/05/21.
//

import UIKit
import Lottie
class AnimationViewController: UIViewController {
    @IBOutlet weak var animationView: UIView!
    var count = 0
    
    var animationV = AnimationView()
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        animation()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [self] (t) in
            self.count = self.count+1
            if(self.count == 5)
            {
                showVC()
                t.invalidate()
            }
            self.navigationController?.navigationBar.isHidden = true
        }
        func animation()  {
            animationV.animation = Animation.named("welcome")
            animationV.frame = animationView.bounds
            animationV.backgroundColor = .clear
            animationV.contentMode = .scaleAspectFit
            animationV.play()
            animationV.loopMode = .loop
            animationView.addSubview(animationV)
        }
        func showVC() {
            let vc = storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    
    
}
