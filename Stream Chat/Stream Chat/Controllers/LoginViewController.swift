//
//  ViewController.swift
//  Stream Chat
//
//  Created by Aurelio Le Clarke on 13.12.2022.
//

import UIKit


final class LoginViewController: UIViewController {

    private let userNameField: UITextField = {
       
        let text = UITextField()
        text.placeholder = "Username"
        text.autocapitalizationType = .none
        text.autocorrectionType = .no
        text.leftViewMode = .always
        text.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 50))
        text.translatesAutoresizingMaskIntoConstraints = false
        text.backgroundColor = .secondarySystemBackground
        return text
    }()
    private let button: UIButton = {
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        
        
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "iOS chatApp"
        view.backgroundColor = .systemBackground
        view.addSubview(userNameField)
        view.addSubview(button)
        button.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
        addConstraints()
    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        userNameField.becomeFirstResponder()
        
        if ChatManager.shared.isSignedin {
            presentChatList(animated: false)
        }
    }

    private func addConstraints() {
        NSLayoutConstraint.activate([
            userNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 50),
            userNameField.leftAnchor .constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 50),
            userNameField.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -50),
            userNameField.heightAnchor.constraint(equalToConstant: 50),
            
            button.topAnchor.constraint(equalTo: userNameField.bottomAnchor,constant: 20),
            button.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 50),
            button.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -50),
            button.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    @objc private func didTapContinue() {
        userNameField.resignFirstResponder()
        guard let text  = userNameField.text, !text.isEmpty else { return }
        ChatManager.shared.signIn(with: text) { [weak self] success in
            guard success else {
                return
            }
            print("did login")
            //Take user to chat list
            
            DispatchQueue.main.async {
                self?.presentChatList(animated: false)
            }
        }
    }
    
    func presentChatList(animated: Bool = true) {
        print("Should show chat list")
        guard let vc =  ChatManager.shared.createChannelList() else { return }
        
        vc.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapCompose))
        vc.navigationItem.rightBarButtonItem?.tintColor = .label
     
        let tabVC = TabBarViewController(chatList: vc)
        tabVC.modalPresentationStyle = .fullScreen
        
        present(tabVC, animated: animated)
    }

    @objc func didTapCompose() {
        let alert = UIAlertController(title: "New Chat", message: "Enter channel name", preferredStyle: .alert)
        
        alert.addTextField()
        alert.addAction(.init(title: "Cancel", style: .cancel))
        alert.addAction(.init(title: "Create", style: .default,handler: { _ in
            guard let text = alert.textFields?.first?.text, !text.isEmpty  else { return }
           
            DispatchQueue.main.async {
                ChatManager.shared.createNewChannel(name: text)
            }
            
        }))
        presentedViewController?.present(alert,animated: true )
    }
}

