//
//  MessagesVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 14/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import Starscream
import IQKeyboardManager

class MessagesVC: UIViewController {
    @IBOutlet weak var tableViewMessages: UITableView!
    @IBOutlet var chatInputView: ChatInputView!
    @IBOutlet var chatContainer: UIView!
    
    @IBOutlet weak var labelName: UILabel!
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var textViewMsg: UITextView!
    
    @IBOutlet weak var heightHeader: NSLayoutConstraint!
    
    override var inputAccessoryView: ChatInputView {
        return chatInputView
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    var isstart:Bool = false
    let messagePlaceholder = "Start typing here..."
    var chat: ChatList!
    
    var arrayMessages = [MessageList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        setupView()
        addObservers()
        startSocket()
        getMessages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(willBecomeActive), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    @objc func willBecomeActive(_ notification: Notification) {
        getMessages()
    }
    
    func setupNavigation() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func setupView() {
        tableViewMessages.estimatedRowHeight = 50
        tableViewMessages.rowHeight = UITableView.automaticDimension
        if SCREEN_HEIGHT > 800 {
            heightHeader.constant = 104
        } else {
            heightHeader.constant = 84
        }
        imageViewUser.setCornerRadius(20.0, borderWidth: 0, borderColor: .clear)
        chatContainer.setCornerRadius(20.0, borderWidth: 0, borderColor: .clear)
        
        let strImage = imageBucket + (chat.image ?? "")
        imageViewUser.kf.setImage(with: URL(string: strImage), placeholder: UIImage(named: "user_profile"))
        labelName.text = chat.groupName ?? ""
        textViewMsg.text = messagePlaceholder
    }
    
    deinit {
        removeObservers()
    }
    
    func addObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillBeHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeObservers() {
        let notificationCenter = NotificationCenter.default
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        notificationCenter.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @IBAction func back() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWasShown(notification: NSNotification) {
        if isstart == false {
            return
        }
        
        if let newFrame = (notification.userInfo?[ UIResponder.keyboardFrameEndUserInfoKey ] as? NSValue)?.cgRectValue {
            
            let insets = UIEdgeInsets( top: 0, left: 0, bottom: newFrame.height - 60, right: 0 )
            tableViewMessages.contentInset = insets
            tableViewMessages.scrollIndicatorInsets = insets
            
            if self.arrayMessages.count > 0 {
                let indexPath = IndexPath(row: self.arrayMessages.count - 1, section: 0)
                self.tableViewMessages.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification) {
        isstart = false
        let insets = UIEdgeInsets( top: 0, left: 0, bottom: 0, right: 0 )
        tableViewMessages.contentInset = insets
        tableViewMessages.scrollIndicatorInsets = insets
    }
    
    @IBAction func sendButtonAction() {
        if !SocketIOManager.shared.checkConnection() {
            SocketIOManager.shared.connectSocket { (status) in
            }
            return
            
        }
        if textViewMsg.text != messagePlaceholder && !textViewMsg.text.isEmpty {
            self.sendMessage(textViewMsg.text)
            textViewMsg.text = ""
        }
    }
    
}

//MARK :- UITextView Delegates
extension MessagesVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        isstart = true
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        let currentText:String = textView.text
        let updatedText = (currentText as NSString).replacingCharacters(in: range, with: text)
        if updatedText.isEmpty {
            textView.text = messagePlaceholder
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        } else if textView.text == messagePlaceholder && !text.isEmpty {
            textView.text = text
        } else {
            return true
        }
        return false
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == messagePlaceholder {
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = messagePlaceholder
        }
    }
}

extension MessagesVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayMessages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var identifier = "IncomingCell"
        let message = arrayMessages[indexPath.row]
        
        if let userData = CommonFunctions.getUserDetailFromUserDefault() {
            if message.senderID == userData.parentData.parentID {
                identifier = "OutgoingCell"
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier) as! MessageCell
        cell.setupCellWith(message: message)
        
        return cell
    }
    
}

//APIs
extension MessagesVC {
    func getMessages() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        let url = ServiceAPI.api_message_list.urlString() + "\(chat.groupID ?? 0)"
        Services.makeRequest(forStringUrl: url, method: .get, parameters: nil) { (response, error) in
            CommonFunctions.hideHUD(controller: self)
            if (error != nil) {
                self.showCustomAlertWith(
                    message: error ?? "",
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return }
                let model = try! JSONDecoder().decode(MessageListResponse.self, from: data)
                self.arrayMessages = model.data
                self.tableViewMessages.reloadData()
                if self.arrayMessages.count > 0 {
                    let indexPath = IndexPath(row: self.arrayMessages.count - 1, section: 0)
                    self.tableViewMessages.scrollToRow(at: indexPath, at: .bottom, animated: false)
                    self.markMessageAsRead()
                }
            }
        }
    }
}

//Socket
extension MessagesVC {
    
    func startSocket() {
        SocketIOManager.shared.connectSocket { (isConnected) in
            self.joinChat()
        }
    }
    
    func joinChat() {
        let param = [
            "groupId": "\(chat.groupID ?? 0)",
        ]
        SocketIOManager.Events.joinMessageUpdates.emit(params: param)
        self.setSocketListner()
    }
    
    func sendMessage(_ message: String) {
        guard let userData = CommonFunctions.getUserDetailFromUserDefault() else { return  }
        let params = [
            "groupId": "\(chat.groupID ?? 0)",
            "parentId": userData.parentData.parentID,
            "message": message
        ]
        SocketIOManager.Events.sendMessage.emit(params: params)
    }
    
    func markMessageAsRead() {
        guard let userData = CommonFunctions.getUserDetailFromUserDefault() else { return  }
        let params = [
            "groupId": "\(chat.groupID ?? 0)",
            "parentId": userData.parentData.parentID,
            "messageId": "\(arrayMessages.last?.messageID ?? 0)"
        ]
        SocketIOManager.Events.readMessage.emit(params: params)
        
    }
    
    func setSocketListner() {
        SocketIOManager.Events.newMessageListener.listen { [weak self] (result) in
            let array = (result as? NSArray)
            let json =  array?.firstObject as? [String: Any]
            let message = MessageList(
                messageID: (json?["id"] as? Int) ?? 0,
                groupID: (json?["groupId"] as? Int) ?? 0,
                senderID: json?["senderId"] as? String ?? "" ,
                createdOn: json?["createdOn"] as? String  ?? "",
                status: json?["status"] as? String  ?? "",
                message: json?["message"] as? String  ?? "", senderName: json?["fullName"] as? String  ?? ""
            )
            self?.appendMessageInList(message)
            self?.markMessageAsRead()
        }
    }
    
    func appendMessageInList(_ message: MessageList) {
        arrayMessages.append(message)
        let indexPath = IndexPath(row: self.arrayMessages.count - 1, section: 0)
        tableViewMessages.insertRows(at: [indexPath], with: .automatic)
        self.tableViewMessages.scrollToRow(at: indexPath, at: .bottom, animated: false)
    }
}
