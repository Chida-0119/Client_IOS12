//
//  MyProfileSetting.swift
//  Client_IOS12
//
//  Created by 千田伸一郎 on 2020/03/16.
//  Copyright © 2020 千田伸一郎. All rights reserved.
//

import UIKit

class MyProfileSetting:  UIViewController,UIPickerViewDelegate,UIPickerViewDataSource {
 
    private struct _Employee {
        var id: Int
        var name: String
        var address: String
    }
    private var _data: [_Employee] = []
    
    //@IBOutlet weak var myProfilePicker: UIPickerView!
    @IBOutlet weak var myProfileUser: UITextField!
    let pickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: pickerView.bounds.size.height)
        pickerView.delegate   = self
        pickerView.dataSource = self

        let vi = UIView(frame: pickerView.bounds)
        vi.backgroundColor = UIColor.white
        vi.addSubview(pickerView)

        myProfileUser.inputView = vi

        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        let doneButton   = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.donePressed))
        let cancelButton = UIBarButtonItem(title: "Cancel", style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.cancelPressed) )
        let spaceButton  = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        myProfileUser.inputAccessoryView = toolBar
        
        for (_, e) in UserMaster.shared.users {
            _data.append(_Employee(id:e.id,name:e.name,address:e.address))
        }
        _data.sort(by: {(first, second) -> Bool in first.id < second.id} )
    }
    
    // Done
    @objc func donePressed() {
        let _address = _data[pickerView.selectedRow(inComponent: 0)].address
        myProfileUser.text = _data[pickerView.selectedRow(inComponent: 0)].name
        if myProfileUser.text != "" {
            MyProfile.shared.setProfile(address: _address)
            myProfileUser.text = _data[pickerView.selectedRow(inComponent: 0)].name
            view.endEditing(true)
            
            //Storyboardを指定
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            //Viewcontrollerを指定
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "UserMain")
            self.dismiss(animated: false)
            UIApplication.shared.keyWindow?.rootViewController = initialViewController
        //表示
            UIApplication.shared.keyWindow?.makeKeyAndVisible()
//        performSegue(withIdentifier: "toUserMain", sender: nil)
        }
    }

    // Cancel
    @objc func cancelPressed() {
        view.endEditing(true)
    }

   override func viewWillAppear(_ animated: Bool) {
        //myProfileUser.text = _data[pickerView.selectedRow(inComponent: 0)].name
    }
 
    //ひとつのPickerViewに対して、横にいくつドラムロールを並べるかを指定。通常は1でOK
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
 
//PickerViewの選択肢の個数を返す処理。複数のpickerViewがある場合は、tagをStoryboard上で設定して場合分けをする
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return _data.count
    }
    
//PickerViewの選択肢として表示する文字列を設定（これがないと、?として表示されてしまう）
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        return _data[row].name
    }

/*
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if myProfile.index != pickerView.selectedRow(inComponent: 0) {
            myProfile.setProfile(index: pickerView.selectedRow(inComponent: 0) )
        }
    }
*/
}



