//
//  SettingsViewController.swift
//  Stream Chat
//
//  Created by Aurelio Le Clarke on 04.01.2023.
//

import UIKit

final class SettingsViewController: UIViewController {

    
    private let imageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "person.circle")
        image.contentMode = .scaleAspectFit
        
        return image
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 24,weight: .medium)
        
        return label
    }()
    
    
    private let button: UIButton = {
      let button  = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Sign out", for: .normal)
        button.setTitleColor(.red, for: .normal)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(button)
        view.addSubview(label)
        view.addSubview(imageView)
        label.text = ChatManager.shared.currentUser
        title = "Settings"
        view.backgroundColor = .systemBackground
        addConstraints()
        button.addTarget(self, action: #selector(didTapSignOut), for: .touchUpInside)
        
    }
    @objc func didTapSignOut() {
        ChatManager.shared.signOut()
        let vc = UINavigationController(rootViewController: LoginViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
        
            imageView.widthAnchor.constraint(equalToConstant: 100),
            imageView.heightAnchor.constraint(equalToConstant: 100),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.leftAnchor.constraint(equalTo: view.leftAnchor),
            label.rightAnchor.constraint(equalTo: view.rightAnchor),
            label.heightAnchor.constraint(equalToConstant: 80),
            label.topAnchor.constraint(equalTo: imageView.bottomAnchor,constant: 20),
            
            button.leftAnchor.constraint(equalTo: view.leftAnchor),
            button.rightAnchor.constraint(equalTo: view.rightAnchor),
            button.heightAnchor.constraint(equalToConstant: 50),
            button.topAnchor.constraint(equalTo: label.bottomAnchor,constant: 20)
        ])
    }



}
