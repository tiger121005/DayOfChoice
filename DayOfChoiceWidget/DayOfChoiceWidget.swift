//
//  DayOfChoiceWidget.swift
//  DayOfChoiceWidget
//
//  Created by TAIGA ITO on 2024/05/27.
//

import WidgetKit
import SwiftUI
import RealmSwift
import Firebase
import FirebaseFirestore
import AppIntents

//Widgetの更新タイミングを提供
struct Provider: TimelineProvider {
    
    //データを取得するまでに表示されるデータ
    func placeholder(in context: Context) -> WidgetData {
        WidgetData(date: Date(), question: "読み込み中", select1: "", select2: "")
    }
    
    //Widget作成画面で表示するデータ
    func getSnapshot(in context: Context, completion: @escaping (WidgetData) -> ()) {
        let entry = WidgetData(date: Date(), question: "休みの日は？", select1: "家", select2: "外")
        completion(entry)
    }
    
    //データを取得後に表示するデータ
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        
        print("start")
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        Task {
            print("in task")
            var realm: Realm {
                var config = Realm.Configuration()
                let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
                config.fileURL = url?.appendingPathComponent("db.realm")
                let realm = try! Realm(configuration: config)
                return realm
            }
            
            print("before judge")
        
            
            if let realmData = realm.object(ofType: RealmData.self, forPrimaryKey: formatter.string(from: currentDate)) {
                print("select", realmData.select)
                if realmData.select != 0 {
                    let entries = [WidgetData(date: currentDate,
                                              question: "次の質問を待ってね",
                                              select1: "",
                                              select2: "")]
                    completion(Timeline(entries: entries, policy: .atEnd))
                    return
                }
            
                
                if realmData.question == "取得失敗" {
                    let question = await getQuestion()
                    let entries = [WidgetData(date: currentDate,
                                              question: question.question,
                                              select1: question.select1,
                                              select2: question.select2)]
                    
                    completion(Timeline(entries: entries, policy: .atEnd))
                    return
                }
                
                print("before entries")
                print("question", realmData.question)
                print("select1", realmData.select1)
                print("select2", realmData.select2)
                
                let entries = [WidgetData(date: currentDate,
                                          question: realmData.question,
                                          select1: realmData.select1,
                                          select2: realmData.select2)]
                print("before completion")
                completion(Timeline(entries: entries, policy: .atEnd))
            } else {
                
                print("start get question")
                let question = await getQuestion()
                let entries = [WidgetData(date: currentDate,
                                          question: question.question,
                                          select1: question.select1,
                                          select2: question.select2)]
                completion(Timeline(entries: entries, policy: .atEnd))
                
            }
        }
    }
    
    func getQuestion() async -> Question {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        let currentDate = Date()
        FirebaseApp.configure()
        let db = Firestore.firestore()
        let id  = formatter.string(from: currentDate)
        print(id)
        do {
            let question = try await db.collection("question").document(String(id.suffix(4))).getDocument(as: Question.self)
            
            var realm: Realm {
                var config = Realm.Configuration()
                let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
                config.fileURL = url?.appendingPathComponent("db.realm")
                let realm = try! Realm(configuration: config)
                return realm
            }
            
            let realmData = RealmData()
            realmData.question = question.question
            realmData.select1 = question.select1
            realmData.select2 = question.select2
            realmData.id = formatter.string(from: currentDate)
            try! realm.write {
                realm.add(realmData)
            }
            print(Question(question: question.question,
                           select1: question.select1,
                           select2: question.select2))
            return Question(question: question.question,
                            select1: question.select1,
                            select2: question.select2)
        } catch {
            print("Error get question at widget 2")
            return Question(question: "取得失敗",
                            select1: "",
                            select2: "")
        }
    }
}


struct WidgetData: TimelineEntry  {
    
    var date: Date
    
    let question: String
    let select1: String
    let select2: String
}

struct DayOfChoiceWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family: WidgetFamily

    var body: some View {
        
        switch family {
        case .systemSmall:
            SmallWidget(entry: entry)
                
        case .systemMedium:
            MediumWidget(entry: entry)
            
        default:
            Text("")
        }
        
    }
}

struct SmallWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        Text(entry.question)
    }
}

struct MediumWidget: View {
    var entry: Provider.Entry
    
    @State private var select = 0
    
    var body: some View {
        VStack {
//            Text(entry.question)
            Text("犬派？猫派？")
                .frame(alignment: .center)
            
            HStack {
                Button(intent: Select1Intent()) {
                    Text(entry.select1)
                    Text("犬")
                        .frame(width: 120, height: 60)
                        
                        
                }
                .background(
                    RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                        .fill(Color(uiColor: UIColor(red: 1, green: 0.1, blue: 0.1, alpha: 1)))
                )
                
                .tint(.white)
                
                Button(intent: Select2Intent()) {
//                    Text(entry.select2)
                    Text("猫")
                        .frame(width: 120, height: 60)
                         
                }
                .background(
                    RoundedRectangle(cornerRadius: .infinity, style: .continuous)
                        .fill(Color(uiColor: UIColor(red: 0, green: 0.15, blue: 1, alpha: 1)))
                )
                .tint(.white)
            }
            
        }
        
    }
}

@main
struct DayOfChoiceWidget: Widget {
    let kind: String = "DayOfChoiceWidget"
    @Environment(\.widgetFamily) var family
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                DayOfChoiceWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                DayOfChoiceWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("ニッタク")
        .description("ここからその日の質問を見ることができます。")
        .supportedFamilies([.systemSmall,.systemMedium])
    }
    
    
}


final class Vote {
    private static var select = 0
    
    static func vote(select: Int) {
        Task {
            
            FirebaseApp.configure()
            let db = Firestore.firestore()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let year = String(formatter.string(from: Date()).prefix(4))
            let date = String(formatter.string(from: Date()).suffix(4))
            
            guard let uid = UserDefaultsKey.uid.get() else {
                print("Cannnot get uid")
                return
            }
            
            let id = formatter.string(from: Date())
            do {
                var realm: Realm {
                    var config = Realm.Configuration()
                    let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
                    config.fileURL = url?.appendingPathComponent("db.realm")
                    let realm = try! Realm(configuration: config)
                    return realm
                }
                if let updatedata = realm.object(ofType: RealmData.self, forPrimaryKey: id) {
                    
                    try! realm.write {
                        updatedata.select = select
                    }
                    
                    print("Add", realm.objects(RealmData.self))
                }
                
                try db.collection("user").document(uid).collection("answers").document(id).setData(from: Answer(select: select))
                
                
                
                
            } catch {
                print("Error add answer")
            }
            
            
            do {
                try await db.collection("question").document(date).collection("results").document(year).updateData([
                    "number\(select)": FieldValue.increment(Int64(1))
                ])
                print("Success vote from widget")
            } catch {
                print("Error add num")
            }
        }
    }
    
}


struct Select1Intent: AppIntent {
    static var title: LocalizedStringResource = "select1"
    
    func perform() async throws -> some IntentResult {
        print("Tap select1 button")
        Vote.vote(select: 1)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}

struct Select2Intent: AppIntent {
    static var title: LocalizedStringResource = "select2"
    
    func perform() async throws -> some IntentResult {
        print("Tap select2 button")
        Vote.vote(select: 2)
        WidgetCenter.shared.reloadAllTimelines()
        return .result()
    }
}


#Preview(as: .systemMedium) {
    DayOfChoiceWidget()
} timeline: {
    WidgetData(date: .now, question: "ここに質問が入る。どれだけいっぱい入るかな？", select1: "ここに選択", select2: "ここに選択")
}
