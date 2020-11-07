//
//  StudentsVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 18/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class StudentsVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var viewModel = StudentsViewModel()    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupGestureForSideMene()
        setupNavigation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getStudents()
    }
    
    func setupNavigation() {
        navigationController?.setTransparentNavigationBar()
    }
    
    func getStudents() {
        CommonFunctions.showHUDOnTop()
        viewModel.getStudents { (status, message) in
            DispatchQueue.main.async {
                CommonFunctions.hideHUDFromTop()
            }
            if status {
                self.collectionView.reloadData()
            } else {
                self.showCustomAlertWith(
                    message: message,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        }
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.prepareSideMenu(segue: segue)
        if segue.destination is AddStudentDetailVC {
            let vc = segue.destination as! AddStudentDetailVC
            vc.isFromStudents = true
            if sender != nil {
                vc.student = sender as! Student
            }
        }
    }
    
    @IBAction func addStudent() {
        performSegue(withIdentifier: "STUDENTS_TO_ADD_STUDENT", sender: nil)
    }

}

extension StudentsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.studentsCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StudentsCell", for: indexPath) as! StudentsCell
        
        if let student = viewModel.getStudent(at: indexPath.row) {
            cell.labelName.text = student.fullName ?? ""
            cell.labelPickup.text = student.schoolName ?? ""
            let remainder = indexPath.row % 3
            if remainder == 0 {
                cell.imageViewUser.image = #imageLiteral(resourceName: "penguin_1")
            } else if remainder == 1 {
                cell.imageViewUser.image = #imageLiteral(resourceName: "penguin_2")
            } else {
                cell.imageViewUser.image = #imageLiteral(resourceName: "penguin_3")
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = SCREEN_WIDTH * (144.0/375.0)
        let height = SCREEN_WIDTH * (188.0/375.0)
        return CGSize(width: width, height: height)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let left = SCREEN_WIDTH * (28.0/375.0)
        return UIEdgeInsets(top: 10, left: left, bottom: 60, right: left)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let student = viewModel.getStudent(at: indexPath.row) {
            performSegue(withIdentifier: "STUDENTS_TO_ADD_STUDENT", sender: student)
        }
    }
}

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let attributes = super.layoutAttributesForElements(in: rect)

        var leftMargin = CGFloat(20.0) //sectionInset.left
        var maxY: CGFloat = -1.0
        attributes?.forEach { layoutAttribute in
            if layoutAttribute.frame.origin.y >= maxY {
                leftMargin = sectionInset.left
            }

            layoutAttribute.frame.origin.x = leftMargin

            leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
            maxY = max(layoutAttribute.frame.maxY , maxY)
        }

        return attributes
    }
}
