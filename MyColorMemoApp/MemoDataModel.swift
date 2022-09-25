//
//  MemoDataModel.swift
//  MyColorMemoApp
//
//  Created by TEN MATSUMOTO on 1/9/2022.
//

import Foundation
import RealmSwift

//メモの"データを構造"を定義したいのでstructを使用する→ Realm導入後はcrassに変更
class MemoDataModel: Object {
    //データを保存する際にはデータの一意性を担保するためにデータ一つ一つに対して固有の識別子を付けることを推奨する。これがないとデータの編集や削除ができなくなってしまう。そのためデータを識別する識別子を定義する↓
    @objc dynamic var id: String = UUID().uuidString //データを一意に識別する為の識別子↑
    @objc dynamic var text: String = ""
    @objc dynamic var recordDate: Date = Date()
}
 
