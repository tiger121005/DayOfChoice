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
    @IBOutlet var copyLabel: UILabel!
    
    var friends: [Friend] = []
    let questionFB = QuestionFirebase.shared
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
        Task {
            await setupLogData()
            setupTableView()
            setuplabel()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await setupFriendData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFriend" {
            let nextVC = segue.destination as! FriendViewController
            nextVC.friendData = selectFriend
        }
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .white
    }
    
    func setupLogData() async {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let logs = realm.objects(RealmData.self).map{Logs(question: $0.question, select1: $0.select1, select2: $0.select2, number1: $0.number1, number2: $0.number2, select: $0.select, id: $0.id)}.sorted{Int($0.id)! > Int($1.id)!}
        
        print("log count", logs.count)
        if logs.count < 2 {
            return
        }
        
        let log = logs[1]
        
        await questionFB.getPreResult(id: log.id, select: log.select)
        dump(realm.objects(RealmData.self))
        
    }

    func setupFriendData() async {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let friendDatas = Array(realm.objects(FriendsData.self))
        
        friends = []
        for data in friendDatas {
            guard let name = await friendFB.getFriendName(id: data.id) else {
                print("error get name")
                continue
            }
            friends.append(Friend(name: name, matchNum: data.matchNum, id: data.id))
            
        }
        tableView.reloadData()
        
    }
    
    func setuplabel() {
        nameLabel.text = UserDefaultsKey.name.get()
        idLabel.text = UserDefaultsKey.uid.get()
        
        copyLabel.isHidden = true
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
    
    @IBAction func copyID() {
        UIPasteboard.general.string = UserDefaultsKey.uid.get() ?? ""
        Task {
            copyLabel.isHidden = false
            try await Task.sleep(nanoseconds: 1 * 1_000_000_000) // Sleep for 2 seconds
            await MainActor.run {
                copyLabel.isHidden = true
            }
        }
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
        cell.textLabel?.text = friends[indexPath.row].name
        cell.backgroundColor = .white
        cell.textLabel?.textColor = .black
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
