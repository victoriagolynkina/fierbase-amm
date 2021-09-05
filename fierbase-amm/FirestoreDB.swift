//
//  FirestoreDB.swift
//  fierbase-amm
//
//  Created by Вика on 06.09.2021.
//

import Foundation
import FirebaseStorage
import Firebase

class FirestoreDB {
    let phoneList = "PhoneList"
    let timeStamp = "timeStamp"
    static let shared = FirestoreDB()

    var db = Firestore.firestore()
    
    func setData(newList: NewList) {
        _ = db.collection(phoneList).addDocument(data: newList.dictionary, completion: {(err) in
            if err != nil {
                print("номер не записан")
            } else {
                print("номер записан")
            }
        })
    }
    
//    func getData(completion: @escaping (NewList?) -> Void) {
//        db.collection("PhoneList").whereField("timeStamp", isGreaterThan: Date().timeIntervalSince1970).addSnapshotListener {(querySnapshot, error) in
//            if let error = error {
//                print("Error", error.localizedDescription)
//            } else {
//                guard let snapshot =  querySnapshot  else {
//                    return
//                }
//                snapshot.documentChanges.forEach({ diff  in
//                    if diff.type == .added  {
//                        if diff.document.data().isEmpty {return}
//                        guard let dict = NewList(dictionary: diff.document.data()) else {return}
//                        completion(dict)
//                    }
//                })
//            }
//        }
//    }
    
    func getData(completion: @escaping (NewList?) -> Void) {
        db.collection(phoneList).whereField(timeStamp, isGreaterThan: Date().timeIntervalSince1970).addSnapshotListener {(querySnapshot, error) in
            if let error = error {
                print("error")
            } else {
                guard let snapshot = querySnapshot else {return}
                snapshot.documentChanges.forEach({diff in
                    if diff.type == .added {
                        if diff.document.data().isEmpty {return}
                        guard let dict = NewList(dictionary: diff.document.data()) else {return}
                        completion(dict)
                    }
                })
            }
        }
    }
    
    func loadData(completion: @escaping ([NewList]?) -> Void) {
        db.collection("PhoneList").getDocuments {(querySnapshot, error) in
            if let error = error {
                print("Error", error.localizedDescription)
            } else {
                completion(querySnapshot!.documents.compactMap({NewList(dictionary: $0.data())}))
            }
        }
    }
    
}
