//
//  StreamManager.swift
//  Stream Chat
//
//  Created by Aurelio Le Clarke on 29.12.2022.
//

import Foundation
import StreamChat
import StreamChatUI
import UIKit


final class ChatManager {
    
    static let shared = ChatManager()
    
    private var client: ChatClient!
    
    private let tokens = [
        
        "stevejobs": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoic3RldmVqb2JzIn0.cNwTSQhYEDh78nnkPPTD5PvDDpJ6IK5e2147NdydY3k",
        "markz": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoibWFya3oifQ.NCg667bX7xeVQqjVuHvRlNbqEkbr7Q4DmU5OVR1pCtI",
         
    ]
    
    func setup() {
        let client = ChatClient(config: .init(apiKey: .init("zye5wh8qcqdn")))
        self.client = client
        
    }
    
    //Authenticate
    func signIn(with userName: String, completion: @escaping (Bool) -> Void) {
        guard !userName.isEmpty else {
            completion(false)
            return }
        
        guard let token  = tokens[userName.lowercased()] else {
            completion(false)
            return }
        
        client.connectUser(userInfo: UserInfo(id: userName, name: userName),
                           token: Token(stringLiteral: token)) { error in
            completion(error == nil)
        }
                            
        
        
    }
    
    func signOut() {
        client.disconnect {
            self.client.connectionController().disconnect()
        }
        client.logout {
            
        }
     
    }
    
    var isSignedin: Bool {
        return client.currentUserId != nil
        
    }
    
    var currentUser: String? {
        return client.currentUserId
        
    }
    
    //Channel list + Creation
    
    public func createChannelList() -> UIViewController? {
        guard let id = currentUser else { return nil }
        let list = client.channelListController(query: .init(filter:  .containMembers(userIds: [id])))
        let vc = ChatChannelListVC()
        vc.content = list
        list.synchronize()
        return vc
    }
    
    public func createNewChannel(name: String) {
        guard let current =  currentUser else { return }
        let keys: [String] =  tokens.keys.filter({
             $0 != current
        }).map { $0 }
     
        do {
            let result = try client.channelController(createChannelWithId: .init(type: .messaging,
                                                                                 id: name),
                                                                                name: name,
                                                                                members: Set(keys),
                                                                                isCurrentUserMember: true)
        
            result.synchronize()
        }catch {
            print("\(error)")
        }
    }
    
}
