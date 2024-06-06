//
//  AddFriendViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/02.
//

import UIKit
import RealmSwift

class AddFriendViewController: UIViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var resultLabel: UILabel!
    @IBOutlet var becomeBtn: UIButton!
    
    let friendFB = FriendFirebase.shared
    var friend = Friend(name: "", matchNum: 0, id: "")
    
    var delegate: HomeViewDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupBtn()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        delegate?.reloadTableView()
    }
    

    func setupSearchBar() {
        searchBar.delegate = self
    }
    
    func setupBtn() {
        becomeBtn.isEnabled = false
    }
    
    
    @IBAction func tapBecome() {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        if friend.id == "" {
            return
        }
        
        let friendData = FriendsData()
        friendData.matchNum = 0
        friendData.id = friend.id
        
        if realm.object(ofType: FriendsData.self, forPrimaryKey: friend.id) == nil {
            try! realm.write {
                realm.add(friendData)
            }
            
            resultLabel.text = "\(friend.name)と友達になりました！"
            becomeBtn.isEnabled = false
            
        } else {
            resultLabel.text = "\(friend.name)とはすでに友達です！"
            becomeBtn.isEnabled = false
        }
        
    }
    
    @IBAction func close() {
        self.dismiss(animated: true)
    }
    

}

extension AddFriendViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        Task {
            
            guard let word = searchBar.text else {
                print("There is no text in searchBar")
                return
            }
            
            guard let friend = await friendFB.searchFriend(id: word) else {
                print("Cannot find user")
                resultLabel.text = "ユーザーが見つかりませんでした"
                becomeBtn.isEnabled = false
                return
            }
            
            
            self.friend = friend
            resultLabel.text = "\(friend.name)さんが見つかりました！"
            becomeBtn.isEnabled = true
            
        }
    }
}
