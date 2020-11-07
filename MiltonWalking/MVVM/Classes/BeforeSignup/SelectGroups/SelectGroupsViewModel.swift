//
//  SelectGroupsViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

class SelectGroupsViewModel {
    
    private var arrayGroups: [GrouopsDM] = [GrouopsDM]()
    private var arrFilterGroup: [GrouopsDM] = [GrouopsDM]()
    var groupsCount: Int {
        return arrFilterGroup.count
    }
    
    func group(at index: Int) -> GrouopsDM? {
        if arrFilterGroup.count > index {
            return arrFilterGroup[index]
        }
        return nil
    }
    func filterGroupArray(searchText:String, completion: @escaping (Bool) -> Void) {
        self.arrFilterGroup = searchText.isEmpty ? self.arrayGroups : self.arrayGroups.filter { (group) -> Bool in
            return group.groupName.range(of: searchText, options: .caseInsensitive) != nil
        }
        completion(true)
    }
    func getGroups(completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_get_groups.urlString(), method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return }
                do {
                    let data = try JSONDecoder().decode(GroupsBDM.self, from: data)
                    self.arrayGroups = data.data
                } catch let error {
                    self.arrayGroups = []
                    print(error)
                }
                self.arrFilterGroup = self.arrayGroups
                return completion(true, "")
            }
        }
    }
}
