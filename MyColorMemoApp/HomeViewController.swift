//
//  HomeViewController.swift
//  MyColorMemoApp
//
//  Created by TEN MATSUMOTO on 31/8/2022.
//

import Foundation
//UIKitとはiOSに標準で用意されているUIに関するクラスが格納されているモジュール。これをimportすることでcontroller上でそのクラスを使用できる
import UIKit
import RealmSwift
import SwiftUI

//controllerは一般的に"class"で定義する
//HomeViewControllerにUIViewControllerを「クラス継承」(プロトコルの場合は準拠でしたね)する。継承された子クラス(ここではHomeViewController)は、親クラス(ここではUIViewController)の機能をそのまま使用することができるこれを"override"という。子クラスが親クラスの機能を使用する際必ず"override"を記す必要がある
class HomeViewController: UIViewController {
    //"@IBOutlet"はstolyboardから紐付けされたことを表している
    @IBOutlet weak var tableView: UITableView!
    //MemoDataModelファイルから↓
    var memoDataList: [MemoDataModel] = []
    let themeColorTypeKey = "themeColorTypeKey"
    //継承元のUIViewControllerの機能を使用するため"override"
    override func viewDidLoad() {
        //"viewDidLoad"メソッドはこのクラスの画面が表示される際に呼び出されるメソッド
        //画面の表示・非表示に応じて実行されるmethodaを"Lifecycle method"と呼ぶ
        
        //下に定義した"UITableVIewDataSource"はこの"UITableView"にて書きだすことで機能するので忘れずに！↓
        tableView.dataSource = self
        
        //UITableViewのdelegateプロパティにHomeViewControllerクラスを代入することを忘れないようにする↓
        tableView.delegate = self
        
        //UITableViewの仕様によってcellが下で指定した"5"にならない場合がある。その解決としてcellの下に空のフッターを入れる
        //tableFooterView → viewにフッターを追加する
        //UIView　→ 様々なUIコンポーネントの親となる中身がないプレーンなクラス
        tableView.tableFooterView = UIView()
        setNavigationBarButton()
        setLeftNavigationBarButton()
        let themeColorTypeInt = UserDefaults.standard.integer(forKey: themeColorTypeKey)
        let themeColorType = MyColorType(rawValue: themeColorTypeInt) ?? .default
        setThemeColor(type: themeColorType)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setMemoData()
        tableView.reloadData()
    }
    
    //memoDataListにメモデータを格納するためのmethod↓
    func setMemoData () {
        let realm = try! Realm()
        let result = realm.objects(MemoDataModel.self)
        memoDataList = Array(result)
    }
    
    //UINavigationControlleraにボタンを追加する処理↓
    //#selectorに指定するmethodは必ず"@objc"をつける。これはObjective-Cから実行されていることを意味する
    @objc func tapAddButton() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    func setNavigationBarButton() {
        let buttonActionSelector: Selector = #selector(tapAddButton)
        let rightBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: buttonActionSelector)
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    func setLeftNavigationBarButton() {
        let buttonActionSelector: Selector = #selector(didTapColorSettingButton)
        let leftButtonImage = UIImage(named: "ColorSettingIcon")
        let leftButton = UIBarButtonItem(image: leftButtonImage, style: .plain, target: self, action: buttonActionSelector)
        navigationItem.leftBarButtonItem = leftButton
    }
    
    @objc func didTapColorSettingButton() {
        let defaultAction = UIAlertAction(title: "DEFAULT", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .default)
        })
        let orangeAction = UIAlertAction(title: "ORANGE", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .orange)
        })
        let redAction = UIAlertAction(title: "RED", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .red)
        })
        let blueAction = UIAlertAction(title: "BLUE", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .blue)
        })
        let pinkAction = UIAlertAction(title: "PINK", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .pink)
        })
        let greenAction = UIAlertAction(title: "GREEN", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .green)
        })
        let purpleAction = UIAlertAction(title: "PURPLE", style: .default, handler: { _ -> Void in
            self.setThemeColor(type: .purple)
        })
        let cancelAction = UIAlertAction(title: "CANCEL", style: .cancel, handler: nil)
        let alert = UIAlertController(title: "Choose a theme color.", message: "", preferredStyle: .actionSheet)
        
        alert.addAction(defaultAction)
        alert.addAction(orangeAction)
        alert.addAction(redAction)
        alert.addAction(blueAction)
        alert.addAction(pinkAction)
        alert.addAction(greenAction)
        alert.addAction(purpleAction)
        alert.addAction(cancelAction)
      
        
        present(alert, animated: true)
    }
    
    func setThemeColor(type: MyColorType) {
        let isDefault = type == .default
        let tintColor: UIColor = isDefault ? .black : .white
        navigationController?.navigationBar.tintColor = tintColor
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = type.color
        //Dictionary型→ [Key: Value]
        appearance.titleTextAttributes = [.foregroundColor: tintColor]
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        saveThemeColor(type: type)
    }
    
    func saveThemeColor(type: MyColorType) {
        UserDefaults.standard.setValue(type.rawValue, forKey: themeColorTypeKey)
        //UserDefaultsへデータを保存する際、standardプロパティに含まれるsetValueメソッドを使用する。このとき一つ目の引数には保存する値、二つ目の引数にはデータにアクセスするためのキーとなる文字列を渡す。二つ目の引数に渡すキーはアプリ内で一意である必要がある。
    }
}

//UITableViewに表示する内容を定義する↓
extension HomeViewController: UITableViewDataSource {
    //下の"numberOfRowsInSection"はUITableViewに表示するリストの数を定義するmethod
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memoDataList.count
    }
    //下の"cellForRowAt"はUItableViewに表示されるリストの中身(cellという)を定義するmethod
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        //indexPath.row→ UITableViewに表示されるCellの(0から始まる)通し番号が順番に渡される
        let memoDataModel: MemoDataModel = memoDataList[indexPath.row]
        cell.textLabel?.text = memoDataModel.text
        cell.detailTextLabel?.text = "\(memoDataModel.recordDate)"
        return cell
    }
}

//UITableViewを操作した際の挙動を定義する
extension HomeViewController: UITableViewDelegate {
    //didSelectRowAt indexPathはUITableViewのcellがタップされた際、タップされたcellのindex番号が渡されるmethod
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let memoDetailViewController = storyboard.instantiateViewController(identifier: "MemoDetailViewController") as! MemoDetailViewController
        //HomeViewController上で画面遷移をする際に、Dataも一緒に遷移先画面に移す処理↓
        let memoData = memoDataList[indexPath.row]
        memoDetailViewController.configure(memo: memoData)
        tableView.deselectRow(at: indexPath, animated: true)
        navigationController?.pushViewController(memoDetailViewController, animated: true)
    }
    
    //UITableViewをスワイプした際にメモを削除するための処理
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let targetMemo = memoDataList[indexPath.row]
        let realm = try! Realm()
        try! realm.write {
            realm.delete(targetMemo)
        }
        memoDataList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

