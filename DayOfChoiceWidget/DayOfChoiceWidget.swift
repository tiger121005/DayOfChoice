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
        var entries: [WidgetData] = []
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        
        
        var realm: Realm {
            var config = Realm.Configuration()
            let url = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.Ito.taiga.DayOfChoice")
            config.fileURL = url?.appendingPathComponent("db.realm")
            let realm = try! Realm(configuration: config)
            return realm
        }
        
        if let realmData = realm.object(ofType: RealmData.self, forPrimaryKey: formatter.string(from: currentDate)) {
            if realmData.select != 0 {
                entries = [WidgetData(date: currentDate,
                                      question: "次の質問を待ってね",
                                      select1: "",
                                      select2: "")]
                completion(Timeline(entries: entries, policy: .atEnd))
                return
            }
            entries = [WidgetData(date: currentDate,
                                  question: realmData.question,
                                  select1: realmData.select1,
                                  select2: realmData.select2)]
            completion(Timeline(entries: entries, policy: .atEnd))
        } else {
            FirebaseApp.configure()
            let db = Firestore.firestore()
            let id  = formatter.string(from: currentDate).suffix(4)
            print(id)
            db.collection("question").document(String(formatter.string(from: currentDate).suffix(4))).getDocument { (document, err) in
                guard let document else {
                    print("Error get question at widget 1 \(String(describing: err))")
                    completion(Timeline(entries: [WidgetData(date: currentDate, question: "取得失敗", select1: "", select2: "")], policy: .atEnd))
                    
                    return
                }
                do {
                    let fbData = try document.data(as: Question.self)
                    let realmData = RealmData()
                    realmData.question = fbData.question
                    realmData.select1 = fbData.select1
                    realmData.select2 = fbData.select2
                    realmData.id = formatter.string(from: currentDate)
                    try! realm.write {
                        realm.add(realmData)
                    }
                    completion(Timeline(entries: [WidgetData(date: currentDate, question: fbData.question, select1: fbData.select1, select2: fbData.select2)], policy: .atEnd))
                } catch {
                    print("Error get question at widget 2")
                    completion(Timeline(entries: [WidgetData(date: currentDate, question: "取得失敗", select1: "", select2: "")], policy: .atEnd))
                }
            }
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
    
    var body: some View {
        VStack {
            HStack {
                Text(entry.question)
                    .frame(minWidth: 120)
                
                VStack {
                    Button(action: {
                        
                    }, label: {
                        Text(entry.select1)
                            .frame(width: 100)
                    })
                    .tint(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: .infinity,
                            style: .continuous)
                        .fill(.red)
                    )
                    
                    Button(action: {
                        
                    }, label: {
                        Text(entry.select2)
                            .frame(width: 100)
                    })
                    .tint(.white)
                    .background(
                        RoundedRectangle(
                            cornerRadius: .infinity,
                            style: .continuous)
                        .fill(.blue)
                    )
                }
            }
            Button(action: {
                
            }, label: {
                Text("投票")
                    .frame(width: 120)
                    
            })
            .tint(Color(uiColor: .systemBackground))
            .background(RoundedRectangle(
                cornerRadius: .infinity,
                style: .continuous)
                .fill(Color(uiColor: .label)))
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

#Preview(as: .systemSmall) {
    DayOfChoiceWidget()
} timeline: {
    WidgetData(date: .now, question: "ここに質問が入る", select1: "ここに選択", select2: "ここに選択")
}
