//
//  ProfileViewController.swift
//  Sputify
//
//  Created by Kittisak Boonchalee on 8/11/21.
//

import UIKit
import SDWebImage

class ProfileViewController: UIViewController {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var accoutNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var userIDLabel: UILabel!
    @IBOutlet weak var productTypeLabel: UILabel!
    @IBOutlet weak var userSpotifyLinkLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurrentUserProfile()
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "arrow.left"), style: .plain, target: self, action: #selector(backToPrevious))
        // Do any additional setup after loading the view.
    }

    private func getCurrentUserProfile(){
        AuthManager.shared.withVaidToken { token in
            APICaller.shared.provider.request(.getCurrentUserProfile(accessToken: token),callbackQueue: .main) { [weak self] result in
                
                switch result {
                case .success(let response):
                    do {
                        let jsonData = try response.mapJSON() as! [String: Any]
                        if let profile = UserProfile.init(JSON: jsonData) {
                            self?.setupProfile(with: profile)
                        }
                    }
                    catch {
                        print(error.localizedDescription)
                    }
                
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    @objc private func backToPrevious(){
        navigationController?.popViewController(animated: true)
    }
    
    private func setupProfile(with profile: UserProfile){
        profileImageView.layer.masksToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        profileImageView.sd_setImage(with: URL(string: profile.images?.first?.url ?? "")!, completed: nil)
        
        accoutNameLabel.text = profile.displayName
        emailLabel.text = profile.email
        userIDLabel.text = profile.id
        productTypeLabel.text = profile.productType
        userSpotifyLinkLabel.text = profile.externalURL
    }

}
