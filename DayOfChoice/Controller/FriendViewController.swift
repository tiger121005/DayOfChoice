//
//  FriendViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/05.
//

import UIKit
import RealmSwift

class FriendViewController: UIViewController {
    
    @IBOutlet var matchLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    
    var friendData: Friend!
    
    var answers: [Answer] = []
    var questions: [Question] = []
    
    var matchNum = 0
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        Task {
            await getAnswers()
            await getQuestions()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: "CustomCell", bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
    func getAnswers() async {
        answers = await userFB.getAnswers(id: friendData.id)
        
    }
    

    func getQuestions() async {
        Task {
            questions = []
            for answer in answers {
                guard let question = await questionFB.getQuestion(id: answer.id ?? "") else {
                    continue
                }
                
                questions.append(question)
            }
            dump(questions)
            matchNum = 0
            tableView.reloadData()
        }
    }
}

extension FriendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("count", questions.count)
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! CustomCell
        
        let question = questions[indexPath.row]
        let answer = answers[indexPath.row]
        
        if answer.select == 1 {
            cell.answerLabel.text = question.select1
        } else {
            cell.answerLabel.text = question.select2
        }
        
        cell.questionLabel.text = "\(question.question)    \(question.select1) or \(question.select2)"
        
        let realm: Realm = {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }()
        
        print("answer id", answer.id)
        print("answer", answer.select)
        
        guard let myAnswer = realm.object(ofType: RealmData.self, forPrimaryKey: answer.id) else {
            print("Cannot find my answer")
            return cell
        }
        
        if myAnswer.select == 0 {
            return cell
        }
        
        print("myAnswer", myAnswer.select)
        
//        let mySelect = Int.random(in: 1...2)
        
        if myAnswer.select == 1 {
            cell.myAnswerLabel.text = question.select1
        } else {
            cell.myAnswerLabel.text = question.select2
        }
        
        if myAnswer.select == answer.select {
            cell.matchView.backgroundColor = .green
            matchNum += 1
            
            matchLabel.text = "\(matchNum)回"
            print("green")
        } else {
            cell.matchView.backgroundColor = .red
            print("red")
        }
        
        
        return cell
    }
    
}

extension FriendViewController: UITableViewDelegate {
    
}
