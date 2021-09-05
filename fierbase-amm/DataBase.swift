//
//  DataBase.swift
//  fierbase-amm
//
//  Created by Вика on 25.08.2021.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseFirestore
import FirebaseDatabase

class DataBase {
    static let shared = DataBase()
    
    
    func configureFB() -> Firestore {
        var db: Firestore!
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        db = Firestore.firestore()
        return db
    }
    
    func getPost(collection: String, docName: String, completion: @escaping (Document?) -> Void) {
        let db = configureFB()
        db.collection(collection).document(docName).getDocument(completion: { (document, error) in
            guard error == nil else {return}
            let doc = Document(field1: document?.get("field1") as? String ?? "kot4", field2: document?.get("field2") as? String ?? "kot5")
            completion (doc)
        })
    }
    
    func getPost1() {
        Database.database().reference().observeSingleEvent(of: .value, with: { (snap) in
            guard let value = snap.value else {return}
        })
    }
    
    func getImage(picName: String, completion: @escaping (UIImage?) -> Void) {
        let starage = Storage.storage()
        let referenece = starage.reference()
        let pathRef = referenece.child("pictures")
        var image: UIImage = UIImage(named: "default_pic")!
        let fileRef = pathRef.child(picName + ".jpeg")
        fileRef.getData(maxSize: 1024*1024, completion: {(data, error) in
            guard error == nil else {return}
            image = UIImage(data: data!)!
            completion(image)
        })
    }
    
}

