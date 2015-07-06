//
//  Dog.swift
//  Realm_Practice
//
//  Created by nixnoughtnothing on 7/6/15.
//  Copyright (c) 2015 nix nought nothing. All rights reserved.
//

import Foundation
import RealmSwift


// MARK: - Model -

// Dog model
class Dog: Object{
    /// dynamic属性はCoreDataで使われる@dynamic(objC)やNSManaged(swift)と同じ使い方
    dynamic var name = ""
    dynamic var owner: Person? // Can be optional
}


// Person model
class Person: Object{
    dynamic var name = ""
    dynamic var birthdata = NSDate(timeIntervalSince1970: 1)
    /// ListやGenericsプロパティはdynamicとして宣言できないとのこと
    let dogs = List<Dog>()
}








// MARK: - Customizing Models -

// Index
class Book:Object{
    // 宣言と初期化
    dynamic var price = 0
    dynamic var title = ""
    
    // クラスメソッドをoverrideして機能追加もできる
    // indexedProperties()は指定したプロパティにindexを作成するクラスメソッド
    override static func indexedProperties() -> [String]{
        // ["title"]プロパティにindexを作成
        return ["title"]
    }
}


// Primary Key
class Person2:Object{
    // 宣言と初期化
    dynamic var id = 0
    dynamic var name = ""
    
    // primaryKeyを指定するクラスメソッドをoverride
    override static func primaryKey() -> String{
        // "id"をprimaryKeyとして指定
        return "id"
    }
}


// Ignorance
class Person3:Object{
    // 宣言と初期化
    dynamic var tmpID = 0
    dynamic var firstName = ""
    dynamic var lastName = ""
    
    // Getter | Read Only
    var name:String{ // computed properties are automatically ignored
        return "\(firstName) \(lastName)"
    }
    
    // ignoredProperties()クラスメソッドで指定されたプロパティは、Realm に保存されず無視される
    override static func ignoredProperties() -> [String]{
        // ["tmpID"]プロパティは保存されず無視される
        return ["tmpID"]
    }
    
}







// Mark: - Writes -

/**
All changes to an object (addition, modification and deletion) 
must be done within a write TRANSACTION.
(Realm へのオブジェクトの追加、変更、削除は、必ずトランザクションを使うこと）
*/


// Adding objects

// Create Person Object
let author = Person()
author.name = "nix nought nothing"


// Get the default Realm
let realm = Realm()
//=> Tips: you only need to do this once(per thread)

// Add to the Realm inside a TRANSACTION
realm.write{
    realm.add(author)
}



// Updating objects


// Update an Object with a transaction
realm.write{
    author.name = "Ryoh Tsukahara"
}

// Creating a book with the same primary key as a previously saved book
let travelBook = Book()
travelBook.title = "Dive into the world"
travelBook.price = 10
travelBook.id = 1 // new property

// Updating book with id = 1
// Realm モデルクラスで primary key を定義してる場合にオブジェクトを更新する場合や、
// オブジェクトを追加する場合は、Realm().add(_:update:) を使うこと
realm.write{
    realm.add(travelBook, update: true)
}


// Deleting Objects

// delete an object with a TRANSACITON
realm.write{
    // 削除したいオブジェクトを引数にする
    realm.delete(travelBook)
}

// Delte all objects from the realm(Realmに保存されているオブジェクトを全て削除する）
realm.write{
    realm.deleteAll()
}








// MARK - Query -














