//
//  ParentTrackingVM.swift
//  MiltonWalking
//
//  Created by Jitendra Singh on 04/08/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit
import GoogleMaps
class ParentTrackingVM {
    private var arrTripMap = [TripMap]()
    private var arrRoutes = [[String : Any]]()
    //    private var mapView: GMSMapView?
    var arrCordinate:[Int:[Double]] = [0:[25.219167,75.871532], 1:[25.217346,75.879606], 2:[25.218451,75.874540], 3:[25.219085,75.871442], 4:[25.213888,75.866715], 5:[25.209441,75.863576], 6:[25.206016,75.862102], 7:[25.192341,75.858750], 8:[25.178325,75.853289], 9:[25.166897,75.851439], 10:[25.160149,75.852017], 11:[25.178325,75.853289]]
    
    func getTripData() -> [TripMap] {
        return self.arrTripMap
    }
    
    func getTripDataCount() -> Int {
        return self.arrTripMap.count
    }
    
    func getTipDataFor(index:Int) -> TripMap? {
        guard let trip = self.arrTripMap[safe:index] else { return nil }
        return trip
    }
    func getStudentNumberToPickAndDistanceAndStopName() -> (String, String, String, String) {
        var stopName = ""
        var distance = "0.0 km"
        if self.arrTripMap.isEmpty{
            return getStringDataForDistanceAndNumber(index: 0, studentNumber: "0.0 km", stopName: stopName, distance:distance)
        }
        let numb = (self.arrTripMap.firstIndex(where: {$0.status == "NOT_PICKED"}) ?? (self.arrTripMap.count - 1) )
        if let stopame =  self.arrTripMap[safe:numb]?.stopName{
            stopName = stopame
        }
        guard let route = arrRoutes.first else {return getStringDataForDistanceAndNumber(index: numb, studentNumber: distance, stopName: stopName, distance:distance)}
        guard let arrLegs = route["legs"] as? [[String : Any]] else {return getStringDataForDistanceAndNumber(index: numb, studentNumber: distance, stopName: stopName, distance:distance)}
        guard let legData = arrLegs[safe:numb]else {return getStringDataForDistanceAndNumber(index: numb, studentNumber: distance,stopName: stopName, distance:distance)}
        guard let distanceData =  legData["distance"] as? [String : Any]  else {return getStringDataForDistanceAndNumber(index: numb, studentNumber: distance, stopName: stopName, distance:distance)}
        distance =  distanceData["text"] as? String ?? "0.0 km"
        return getStringDataForDistanceAndNumber(index: numb, studentNumber: distance,stopName: stopName, distance:distance)
    }
    func manuallyMark(index:Int) {
        guard var trip = self.arrTripMap[safe:index] else { return }
        trip.status = "PICKED"
         self.arrTripMap[index] = trip
    }
    func getStringDataForDistanceAndNumber(index:Int, studentNumber:String, stopName:String, distance:String) -> (String, String, String, String) {
        var strNumber = ""
        switch index {
        case 0:
            strNumber = "Pick up 1st Student"
        case 1:
            strNumber = "Pick up 2nd Student"
        case 2:
            strNumber = "Pick up 3rd Student"
        default:
            strNumber = "Pick up \(index + 1)th Student"
        }
        let studentNumber = "Your next student is \(studentNumber) away."
        return (strNumber, studentNumber, stopName, distance)
    }
    
    func getStudentStopNameDistanceTimePickedStatusFor(index:Int) -> (String, String, String, String, Bool) {
        var studentName = " "
        var stopName = " "
        var distance = " "
        var time = " "
        var isPicked = false
        guard let trip = self.arrTripMap[safe:index] else {return (studentName, stopName,distance,time, isPicked)}
        stopName = trip.stopName
        studentName = trip.studentName
        isPicked = (trip.status != "NOT_PICKED")
        guard let route = arrRoutes.first else {return (studentName,stopName,distance,time, isPicked)}
        guard let arrLegs = route["legs"] as? [[String : Any]] else {return (studentName, stopName,distance,time, isPicked)}
        guard let legData = arrLegs[safe:index]else {return (studentName,stopName,distance,time, isPicked)}
        guard let distanceData =  legData["distance"] as? [String : Any]  else {return (studentName, stopName,distance,time, isPicked)}
        distance = distanceData["text"] as? String ?? "0.0 km"
        guard let durationData =  legData["duration"] as? [String : Any]  else {return (studentName, stopName,distance,time, isPicked)}
        time = durationData["text"] as? String ?? "0 min"
        return (studentName, stopName,distance,time, isPicked)
    }
    func isAllStudnetPickedUp() -> Bool {
        return (self.arrTripMap.filter({$0.status == "NOT_PICKED"})).isEmpty ? true : false
    }
    func setSocketData(response:Any, completion: @escaping (Bool) -> Void) {
        do {
            let jsonString =  ((response as? NSArray)?.firstObject as? String) ?? ""
            let jsonData =  Data(jsonString.utf8)
            let stopMapData = try JSONDecoder().decode(TripMapBDM.self, from: jsonData)
            self.arrTripMap = stopMapData.data.data
            completion(true)
        } catch let error {
            print(error)
            completion(false)
        }
    }
    func apiCallForTripMap(tripId:Int, completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_tripMap.urlString() + "\(tripId)", method: .get, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                guard let data = response?.data else { return completion(true, "")}
                do {
                    let stopMapData = try JSONDecoder().decode(TripMapBDM.self, from: data)
                    self.arrTripMap = stopMapData.data.data
                } catch let error {
                    self.arrTripMap = []
                    print(error)
                }
                return completion(true, "")
            }
        }
    }
    
    func apiCallToStartTrip(tripId:Int, completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_tripStart.urlString() + "\(tripId)", method: .put, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                return completion(true, "")
            }
        }
    }
    func apiCallToStopTrip(tripId:Int, completion: @escaping (Bool, String) -> Void) {
        Services.makeRequest(forStringUrl: ServiceAPI.api_tripStop.urlString() + "\(tripId)", method: .put, parameters: nil) { (response, error) in
            if (error != nil) {
                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else if (response?.result.value as? [String : Any]) != nil {
                return completion(true, "")
            }
        }
    }
    func managePinsOnMap(mapView: GMSMapView, completion: @escaping(Bool) -> Void) {
        if arrTripMap.isEmpty{
            return
        }
        arrTripMap.sort { (first, second) -> Bool in
            if (first.pickupCount ?? 0) < (second.pickupCount ?? 0){
                return true
            } 
            return false
        }
//        arrTripMap = arrTripMap.enumerated().map { (index,trip) -> TripMap in
//            var tripT = trip
//            let cord = arrCordinate[index]
//            tripT.stopLocation["1"] = cord?[0]
//            tripT.stopLocation["0"] = cord?[1]
//            return tripT
//        }
        //        let origin = (CLLocationCoordinate2D(latitude: self.arrTripMap.first?.stopLocation["1"] ?? 0, longitude: self.arrTripMap.first?.stopLocation["0"] ?? 0))
        let origin = (CLLocationCoordinate2D(latitude: mapView.myLocation?.coordinate.latitude ?? 0, longitude: mapView.myLocation?.coordinate.longitude ?? 0))
        let destination = (CLLocationCoordinate2D(latitude: self.arrTripMap.last?.stopLocation["1"] ?? 0, longitude: self.arrTripMap.last?.stopLocation["0"] ?? 0))
        var wayPoints = ""
        for (index,item) in arrTripMap.enumerated() {
//            if index == 0{
//                continue
//            }else
                if index == (arrTripMap.count - 1){
                continue
            }else{
                let latitude = item.stopLocation["1"] ?? 0
                let longitude = item.stopLocation["0"] ?? 0
                wayPoints = wayPoints.count == 0 ? "\(latitude),\(longitude)" : "\(wayPoints)%7C\(latitude),\(longitude)"
            }
        }
        let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin.latitude),\(origin.longitude)&destination=\(destination.latitude),\(destination.longitude)&mode=driving&waypoints=\(wayPoints)&key=AIzaSyBdeW3UY7Uw3kmWhv32Sw8ucCUOn9gW9ik"
        
        Services.makeRequest(forStringUrl: url, method: .get, parameters: nil) { (response, error) in
            
            print(response?.request as Any)  // original URL request
            print(response?.response as Any) // HTTP URL response
            print(response?.data as Any)     // server data
            print(response?.result as Any)   // result of response serialization
            
            if (error != nil) {
                completion(false)
                //                return completion(false, error ?? INTERNAL_SERVER_ERROR)
            } else {
                guard let dict = (response?.result.value as? [String : Any]) else { return completion(false)}
                guard let arrRoutes = dict["routes"] as? [[String : Any]] else { return completion(false)}
                self.arrRoutes = arrRoutes
                self.drawPolyLineOnMap(mapView: mapView, completion: { isComplete in
                    completion(true)
                })
            }
        }
    }
    func drawPolyLineOnMap(mapView: GMSMapView,completion: @escaping(Bool) -> Void) {
        guard let route = arrRoutes.first else {return completion(false)}
        let points = (((route["overview_polyline"] as? [String : Any])?["points"]) as? String) ?? ""
        let path = GMSPath.init(fromEncodedPath: points)
        let polyline = GMSPolyline(path: path)
        for (index, item) in self.arrTripMap.enumerated() {
            let cord = (CLLocationCoordinate2D(latitude:item.stopLocation["1"] ?? 0, longitude: item.stopLocation["0"] ?? 0))
            let marker = GMSMarker()
//            if index == 0{
//                marker.icon =  UIImage(named:"start")
//            }else
                if index == (arrTripMap.count - 1){
                marker.icon =  UIImage(named:"TripEnd")
            }else{
                marker.icon =  UIImage(named:"pin")
            }
            marker.userData = index
            marker.position = cord
            marker.tracksInfoWindowChanges = false
            marker.map = mapView
        }
        //            for index in 0...(polyline.path?.count() ?? 0) {
        //                guard let cordinate = path?.coordinate(at: index) else { return }
        //                let marker = GMSMarker()
        //                if index == 0{
        //                    marker.icon =  imageLiteral(resourceName: "start")
        //                }else if index == (arrTripMap.count - 1){
        //                    marker.icon =  imageLiteral(resourceName: "TripEnd")
        //                }else{
        //                    marker.icon =  imageLiteral(resourceName: "pin")
        //                }
        //                marker.userData = index
        //                marker.position = cordinate
        //                marker.tracksInfoWindowChanges = false
        //                marker.map = mapView
        //            }
        let strokeStyles = [GMSStrokeStyle.solidColor(.black), GMSStrokeStyle.solidColor(.clear)]
        let strokeLengths = [NSNumber(value: 15), NSNumber(value: 10)]
        if let path = polyline.path {
            polyline.spans = GMSStyleSpans(path, strokeStyles, strokeLengths, .rhumb)
        }
        polyline.strokeWidth = 3.0
        polyline.map = mapView
        let bounds = GMSCoordinateBounds(path: path!)
        let update = GMSCameraUpdate.fit(bounds, withPadding: 60)
        mapView.animate(with: update)
        completion(true)
    }
    
}
