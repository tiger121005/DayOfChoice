//
//  HomeViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/02.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var idLabel: UILabel!
    
    var friends: [Friend] = []
    let friendFB = FriendFirebase.shared

    override func viewDidLoad() {
        super.viewDidLoad()

        print(1)
        setupTableView()
        print(2)
        setuplabel()
        print(3)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(4)
        setupData()
        print(5)
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.backgroundColor = .white
    }

    func setupData() {
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        let friendDatas = realm.objects(FriendsData.self)
        dump(friendDatas)
        print(friendDatas.count)
        
        Task {
            print("aaaaa")
            for data in friendDatas {
                
                print("in for 1")
                guard let name = await friendFB.getFriendName(id: data.id) else {
                    continue
                }
                print(name)
                print("in for 2")
                friends.append(Friend(name: name, matchNum: data.matchNum, id: data.id))
                print("in for 3")
            }
            print("Reload tableView")
            tableView.reloadData()
        }
    }
    
    func setuplabel() {
        nameLabel.text = UserDefaultsKey.name.get()
        idLabel.text = UserDefaultsKey.uid.get()
    }
}

extension HomeViewController: UITableViewDelegate{
    
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
