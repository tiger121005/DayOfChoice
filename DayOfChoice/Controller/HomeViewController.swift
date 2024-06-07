//
//  HomeViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/02.
//

import UIKit
import RealmSwift
import Firebase
import FirebaseFirestore

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    
    var friends: [Friend] = []
    let friendFB = FriendFirebase.shared
    var selectFriend: Friend!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        let realm: Realm = {
//            var config = Realm.Configuration()
//            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
//            config.fileURL = url?.appendingPathComponent("db.realm")
//            let realm = try! Realm(configuration: config)
//            return realm
//        }()
            
//        guard let data = realm.object(ofType: RealmData.self, forPrimaryKey: "0605") else {
//            print("error get data")
//            return
//        }
//        do {
//            try realm.write {
//                realm.delete(data)
//            }
//        } catch {
//            print("Error delete")
//        }
        

        print(1)
        setupTableView()
        print(2)
        setuplabel()
        print(3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            print(4)
            await setupData()
            print(5)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriend" {
            let nextVC = segue.destination as! FriendViewController
            nextVC.friendData = selectFriend
        }
    }

    func setupTableView() {
        print("in set table view 1")
        tableView.dataSource = self
        print("in set table view 2")
        tableView.delegate = self
        print("in set table view 3")
        
        tableView.backgroundColor = .white
        print("in set table view 4")
    }

    func setupData() async {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
//        friends = realm.objects(FriendsData.self).map{Friend(name: $0.name, matchNum: $0.matchNum, id: $0.id)}
        let friendDatas = Array(realm.objects(FriendsData.self))
        
        for data in friendDatas {
            do {
                print("in for 1")
                
//                let db = Firestore.firestore()
//                let user = try await db.collection("user").document(data.id).getDocument(as: User.self)
                print("name")
                print("in get friend 2")
                let name = "name"
                guard let name = await friendFB.getFriendName(id: data.id) else {
                    print("error get name")
                    continue
                }
                print(name)
                print("in for 2")
                friends.append(Friend(name: "name", matchNum: data.matchNum, id: data.id))
                print("in for 3")
                print(friends)
            } catch {
                print("Error get friend")
            }
        }
        print("Reload tableView")
        tableView.reloadData()
        
    }
    
    func setuplabel() {
        print("in label 1")
        nameLabel.text = UserDefaultsKey.name.get()
        print("in label 2")
        idLabel.text = UserDefaultsKey.uid.get()
        print("in label 3")
    }
    
    @IBAction func changeName() {
        let alert = UIAlertController(title: "名前の変更", message: "変更する名前を入力してください", preferredStyle: .alert)
        var textFieldOnAlert = UITextField()
        
        alert.addTextField { textField in
            textFieldOnAlert = textField
            textFieldOnAlert.returnKeyType = .done
        }
        
        let change = UIAlertAction(title: "変更", style: .default) {action in
            
            guard let name = textFieldOnAlert.text else {
                print("Error get new name")
                return
            }
            if name.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
                return
            }
            UserDefaultsKey.name.set(value: name)
            self.nameLabel.text = name
        }
        
        alert.addAction(change)
        present(alert, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectFriend = friends[indexPath.row]
        performSegue(withIdentifier: "toFriend", sender: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        print("in table view 1")
        cell.textLabel?.text = friends[indexPath.row].name
        print("in table view 2")
        cell.backgroundColor = .white
        print("in table view 3")
        cell.textLabel?.textColor = .black
        print("in table view 4")
        return cell
    }
    
    
}

extension HomeViewController: HomeViewDelegate {
    func reloadTableView() {
        tableView.reloadData()
    }
    
    
}


protocol HomeViewDelegate {
    func reloadTableView()
}
