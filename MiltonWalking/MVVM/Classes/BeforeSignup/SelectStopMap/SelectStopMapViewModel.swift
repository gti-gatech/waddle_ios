//
//  SelectStopMapViewModel.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 04/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation
import GoogleMaps

class SelectStopMapViewModel {
    var arrSelectStopMapData = [SelectStopMapDM]()
    
    func managePinsOnMap(mapView: GMSMapView) {
        var bounds = GMSCoordinateBounds()
        for item in arrSelectStopMapData {
            let marker = GMSMarker()
            marker.icon = #imageLiteral(resourceName: "pin")
            marker.title = item.name
            marker.position = CLLocationCoordinate2D(latitude: item.location["1"] ?? 0, longitude: item.location["0"] ?? 0)
            marker.tracksInfoWindowChanges = false
            marker.map = mapView
            marker.userData = item
            bounds = bounds.includingCoordinate(marker.position)
        }
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView.animate(with: update)
    }
    func getDefaultStopForFirstTime() -> SelectStopMapDM? {
        let defaultStop = self.arrSelectStopMapData.first(where: {$0.stopID == CommonFunctions.getUserDetailFromUserDefault()?.parentData.stopID})
        return defaultStop
    }
    func apiCallForStops(completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_stop.urlString(), method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
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
    func apiCallForGroupeStops(routeID:String,completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_groups_stop.urlString() + routeID, method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
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
    
    func apiCallForGroupeJoin(groupId:String, stopId:String,students:[Int], completion: @escaping (Bool, String) -> Void) {
        let requestParams = [
        "groupId": groupId,
        "stopId": stopId,
        "students": students,
        ] as [String:Any]
        Services.makeRequest(forStringUrl: ServiceAPI.api_groups_join.urlString(), method: .post, parameters: requestParams) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if let responseJSON = response?.result.value as? [String : Any] {
                let responseDic: NSDictionary = responseJSON as NSDictionary
                print("response ->\(responseDic)")
                guard let data = response?.data else { return completion(true, "")}
                return completion(true, "")
            }
        }
    }
}
