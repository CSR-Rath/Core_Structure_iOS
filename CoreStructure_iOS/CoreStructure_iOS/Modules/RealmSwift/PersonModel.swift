//
//  PersonModel.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 30/12/24.
//

import UIKit
import RealmSwift
import AuthenticationServices

class Person: Object, Codable {
    @Persisted(primaryKey: true) var id: String = UUID().uuidString
    @Persisted var name: String = ""
    @Persisted var age: Int = 0
}

class RealmManager {
    private let realm = try! Realm()

    // Fetch all persons
    func fetchPersons() -> [Person] {
        return Array(realm.objects(Person.self))
    }

    // Add a new person
    func addPerson(name: String, age: Int) {
        let person = Person()
        person.name = name
        person.age = age
        
        try! realm.write {
            realm.add(person)
        }
    }

    // Filter person by ID
    func filterPerson(by id: String) -> Person? {
        return realm.object(ofType: Person.self, forPrimaryKey: id)
    }

    // Update person by ID
    func updatePerson(by id: String, newName: String, newAge: Int) {
        guard let person = filterPerson(by: id) else { return }
        
        try! realm.write {
            person.name = newName
            person.age = newAge
        }
    }

    // Delete person by ID
    func deletePerson(by id: String) {
        guard let person = filterPerson(by: id) else { return }
        
        try! realm.write {
            realm.delete(person)
        }
    }
}
