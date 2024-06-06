//
//  FriendViewController.swift
//  DayOfChoice
//
//  Created by TAIGA ITO on 2024/06/05.
//

import UIKit

class FriendViewController: UIViewController {
    
    @IBOutlet var matchLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    let userFB = UserFirebase.shared
    let questionFB = QuestionFirebase.shared
    
    var friendData: Friend!
    
    var answers: [Answer] = []
    var questions: [Question] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func getAnswers() async {
        answers = await userFB.getAnswers(id: friendData.id)
        
    }
    

    func getQuestions() async {
        Task {
            for answer in answers {
                guard let question = await questionFB.getQuestion(id: answer.id ?? "") else {
                    continue
                }
                
                questions.append(question)
            }
        }
    }
}

extension FriendViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        return cell
    }
    
    
}
