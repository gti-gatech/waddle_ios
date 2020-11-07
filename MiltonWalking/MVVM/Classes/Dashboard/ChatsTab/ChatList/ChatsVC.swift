//
//  ChatsVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 10/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ChatsVC: UIViewController {
    
    @IBOutlet weak var tableChats: UITableView!
    @IBOutlet weak var labelError: UILabel!
    lazy var searchBar = UISearchBar(frame: .zero)
    
    var arrayChats = [ChatList]()
    var arrayFilter = [ChatList]()
    
    lazy var dateFormatterServer: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return df
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        labelError.isHidden = true
        self.setupGestureForSideMene()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if AppDelegate.sharedInstance.isFromNotification {
            AppDelegate.sharedInstance.isFromNotification = false
            if AppDelegate.sharedInstance.isFromBackground {
                if let data = AppDelegate.sharedInstance.notificationData?["payload"] as? [String: Any] {
                    let chat = ChatList(
                        groupID: (data["groupId"] as? Int) ?? 0,
                        groupName: (data["groupName"] as? String) ?? "",
                        routeID: 0,
                        image: (data["image"] as? String) ?? "",
                        messageID: (data["messageId"] as? Int) ?? 0,
                        message: (data["message"] as? String) ?? "",
                        senderID: (data["senderId"] as? String) ?? "",
                        createdOn: (data["createdOn"] as? String) ?? "",
                        senderName: nil,
                        totalUnRead: 0)
                    performSegue(withIdentifier: "CHATS_TO_MESSAGES", sender: chat)
                }
            } else {
                getChats()
            }
        } else {
            getChats()
        }
    }
    
    func setupView()  {
        searchBar.placeholder = "Search"
        searchBar.returnKeyType = .default
        searchBar.delegate = self
    }
    
    func setupNavigationBar() {
        self.navigationItem.title = "INBOX"
        CommonFunctions.setRightBarButtonItemWith(image: #imageLiteral(resourceName: "search"), action: #selector(searchAction), view: self)
    }
    
    @objc func searchAction() {
        if navigationItem.titleView == searchBar {
            removeSearchbar()
            CommonFunctions.setRightBarButtonItemWith(image: #imageLiteral(resourceName: "search"), action: #selector(searchAction), view: self)
        } else {
            addSearchbar()
            CommonFunctions.setRightBarButtonItemWith(image: #imageLiteral(resourceName: "cancel"), action: #selector(searchAction), view: self)
        }
        self.tableChats.reloadData()
    }
    
    func addSearchbar()  {
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
    }
    
    func removeSearchbar() {
        searchBar.resignFirstResponder()
        searchBar.text = ""
        arrayFilter = [ChatList]()
        navigationItem.titleView = nil
        labelError.isHidden = true
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.prepareSideMenu(segue: segue)
        
        if segue.destination is MessagesVC {
            let vc = segue.destination as! MessagesVC
            vc.chat = sender as? ChatList
        }
    }

}

extension ChatsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navigationItem.titleView == searchBar {
            return arrayFilter.count
        }
        return arrayChats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        
        cell.viewOnline.isHidden = true
        var chat: ChatList!
        if navigationItem.titleView == searchBar {
            chat = arrayFilter[indexPath.row]
        } else {
            chat = arrayChats[indexPath.row]
        }
        
        cell.labelName.text = chat.groupName ?? ""
        cell.labelMessage.text = chat.message ?? ""
        
        let strImage = imageBucket + (chat.image ?? "")
        cell.imageViewUser.kf.setImage(with: URL(string: strImage), placeholder: UIImage(named: "user_profile"))
        
        cell.labelUnreadCount.isHidden = (chat.totalUnRead ?? 0) == 0
        cell.labelUnreadCount.text = "\(chat.totalUnRead ?? 0)"
        cell.labelName.textColor = (chat.totalUnRead ?? 0) == 0 ? COLOR_LIGHT_BLUE_GRAY : COLOR_PRIMARY_ORANGE

        guard let date = dateFormatterServer.date(from: chat.createdOn ?? "") else {
            cell.labelTime.text = ""
            return cell
        }
        if Date().isSameAs(date) {
            let df = DateFormatter()
            df.dateFormat = "HH:mm a"
            cell.labelTime.text = df.string(from: date)
        } else {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            cell.labelTime.text = df.string(from: date)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chat: ChatList!
        if navigationItem.titleView == searchBar {
            chat = arrayFilter[indexPath.row]
        } else {
            chat = arrayChats[indexPath.row]
        }
        performSegue(withIdentifier: "CHATS_TO_MESSAGES", sender: chat)
    }
}

extension ChatsVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        arrayFilter = arrayChats.filter { ($0.groupName!).range(of: searchText, options: [.diacriticInsensitive, .caseInsensitive]) != nil }

        self.tableChats.reloadData()
        labelError.isHidden = arrayFilter.count > 0
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension ChatsVC {
    func getChats() {
        if !CommonFunctions.isNetworkReachable() {
            self.showCustomAlertWith(message: NO_INTERNET_CONNECTION, descMsg: "", itemimage: nil, actions: nil)
            return
        }
        CommonFunctions.showHUD(controller: self)
        let url = ServiceAPI.api_chat_list.urlString()
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
                let response = try! JSONDecoder().decode(ChatListResponse.self, from: data)
                self.arrayChats = response.data
                self.labelError.isHidden = self.arrayChats.count > 0
                self.tableChats.reloadData()
            }
        }
    }
}
