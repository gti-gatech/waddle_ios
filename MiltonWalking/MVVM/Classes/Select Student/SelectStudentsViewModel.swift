//
//  SelectStudentsViewModel.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 07/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import Foundation

class SelectStudentsViewModel {
    
    private var arrayStudents: [StudentDM] = [StudentDM]()
        
    var studentsCount: Int {
        return arrayStudents.count
    }
    func updateArrStudents(arrayStudents:[StudentDM]) {
        self.arrayStudents = arrayStudents
    }
    func student(at index: Int) -> StudentDM? {
        if arrayStudents.count > index {
            return arrayStudents[index]
        }
        return nil
    }
    
    func getStudents(completion: @escaping (Bool, String) -> Void) {
        completion(true, "")
    }
    
}
