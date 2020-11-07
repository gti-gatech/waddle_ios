//
//  GroupsViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 28/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation
import GoogleMaps

class GroupsViewModel {
    
    private var groupsResponse: MyGroupsResponse?
    var arrSelectStopMapData = [SelectStopMapDM]()

    var groupsCount: Int {
        return groupsResponse?.data.count ?? 0
    }
    
    func group(at index: Int) -> Group? {
        if let respose = groupsResponse {
            if respose.data.count > index {
                return respose.data[index]
            }
        }
        return nil
    }
    
    func getGroups(completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_my_groups.urlString(), method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return }
                do {
                    self.groupsResponse = try JSONDecoder().decode(MyGroupsResponse.self, from: data)
                } catch let error {
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
    
    
    func managePinsOnMap(mapView: GMSMapView) {
        var bounds = GMSCoordinateBounds()
        for item in arrSelectStopMapData {
            let marker = GMSMarker()
            marker.icon = #imageLiteral(resourceName: "pin")
            marker.position = CLLocationCoordinate2D(latitude: item.location["1"] ?? 0, longitude: item.location["0"] ?? 0)

            if let user = CommonFunctions.getUserDetailFromUserDefault() {
                if user.parentData.stopID == item.stopID {
                    marker.icon = #imageLiteral(resourceName: "home")
//                    mapView.camera = GMSCameraPosition.camera(withTarget: marker.position, zoom: 14.0)
                }
            }
            marker.tracksInfoWindowChanges = false
            marker.map = mapView
            marker.userData = item
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView.animate(with: update)
    }
    
    func apiCallForStops(completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_stop.urlString(), method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return completion(true, "")}
                do {
                    let stopMapData = try JSONDecoder().decode(SelectStopMapBaseDM.self, from: data)
                    self.arrSelectStopMapData = stopMapData.data ?? []
                } catch let error {
                    self.arrSelectStopMapData = []
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
    
    func leaveGroup(_ groupId: Int, completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_leave_group.urlString() + "\(groupId)", method: .post, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                return completion(true, "")
            }
        }
    }
    
}
