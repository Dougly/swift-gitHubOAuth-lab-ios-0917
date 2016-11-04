//
//  LoginViewController.swift
//  GitHubOAuth
//
//  Created by Joel Bell on 7/28/16.
//  Copyright © 2016 Flatiron School. All rights reserved.
//

import UIKit
import Locksmith
import SafariServices

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var imageBackgroundView: UIView!
    
    @IBOutlet weak var safariBrowser: SFSafariViewController?
    
    
    let numberOfOctocatImages = 10
    var octocatImages: [UIImage] = []
    static var codeForVarification = ""
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpImageViewAnimation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(safariLogin), name: .closeSafariVC, object: nil)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loginImageView.startAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loginImageView.stopAnimating()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureButton()

    }
    
    // MARK: Set Up View
    
    private func configureButton() {
        
        self.imageBackgroundView.layer.cornerRadius = 0.5 * self.imageBackgroundView.bounds.size.width
        self.imageBackgroundView.clipsToBounds = true
    }
    
    private func setUpImageViewAnimation() {
        
        for index in 1...numberOfOctocatImages {
            if let image = UIImage(named: "octocat-\(index)") {
                octocatImages.append(image)
            }
        }
        
        self.loginImageView.animationImages = octocatImages
        self.loginImageView.animationDuration = 2.0
        
    }
    
    // MARK: Action
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        safariBrowser = SFSafariViewController(url: GitHubRequestType.oauth.url)
        
        if let safariBrowser = safariBrowser {
            self.present(safariBrowser, animated: true, completion: nil)
        }
    
    }
    
    func safariLogin(_ notification: Notification) {
        let urlWithCode = notification.object as! URL
        safariBrowser?.dismiss(animated: true, completion: nil)
        
        GitHubAPIClient.request(.token(url: urlWithCode)) { (json, starred, error) in
            if error == nil {
                NotificationCenter.default.post(name: .closeLoginVC, object: nil)
            }
        }
    }
    
    

}







