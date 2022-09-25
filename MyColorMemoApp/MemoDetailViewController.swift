//
//  MemoDetailViewController.swift
//  MyColorMemoApp
//
//  Created by TEN MATSUMOTO on 2/9/2022.
//

import UIKit
import RealmSwift

class MemoDetailViewController: UIViewController {
    @IBOutlet weak var textView: UITextView!
    
    //var text: String = ""
    //var recordDate: Date = Date()  この二つをMemoDataModelに書き換える↓
    var memoData = MemoDataModel()
    
    //これはコンピューテッドプロパティ↓
    var dateFormat: DateFormatter {
     let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        displayData()
        setDoneButton()
        textView.delegate = self
    }
    
    //MemoDetailControllerにMemoDataを渡すためのmethod↓
    func configure(memo: MemoDataModel) {
        memoData.text = memo.text
        memoData.recordDate = memo.recordDate
    }
    
    func displayData() {
        textView.text = memoData.text
        navigationItem.title = dateFormat.string(from: memoData.recordDate)
    }
    
    //キーボードを閉じるための処理↓
    @objc func tapDoneButton() {
        view.endEditing(true)
    }
    //キーボード上に"Done"ボタンを設置するための処理↓
    func setDoneButton() {
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        let commitButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(tapDoneButton))
        toolBar.items = [commitButton]
        textView.inputAccessoryView = toolBar
    }
    
    func saveData(with text: String) {
        let realm = try! Realm()
        try! realm.write {
            memoData.text = text
            memoData.recordDate = Date()
            realm.add(memoData)
        }
        print("text: \(memoData.text), recordDate: \(memoData.recordDate)")
    }
}

extension MemoDetailViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        let updatedText = textView.text ?? ""
        saveData(with: updatedText)
    }
}
