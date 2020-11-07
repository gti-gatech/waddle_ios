//
//  ScheduleVC.swift
//  MiltonWalking
//
//  Created by Krishna Datt Shukla on 15/07/20.
//  Copyright © 2020 Appzoro. All rights reserved.
//

import UIKit

class ScheduleVC: UIViewController {

    @IBOutlet weak var viewTopLine: UIView!
    @IBOutlet weak var viewListContainer: UIView!
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var switchSupervisor: UISwitch!

    let menuDropDown = DropDown()
    var isSupervisor = false
    var selectedDateStr = ""
    
    lazy var dateFormatterServer: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return df
    }()

    let defaultCalendar: Calendar = {
        var calendar = Calendar.current
        calendar.firstWeekday = 1
        calendar.timeZone = .current
        return calendar
    }()
    
    @IBOutlet weak var btnAddSchedule: UIButton!
    @IBOutlet weak var errorlabel: UILabel!

    @IBOutlet weak var monthHeaderView: VAMonthHeaderView! {
        didSet {
            let appereance = VAMonthHeaderViewAppearance(
                monthFont: UIFont(name: "HelveticaNeue-Light", size: 18.0)!,
                monthTextColor: COLOR_DARK_BLUE_GRAY,
                previousButtonImage: #imageLiteral(resourceName: "back_blue"),
                nextButtonImage: #imageLiteral(resourceName: "next_blue")
            )
            monthHeaderView.delegate = self
            monthHeaderView.backgroundColor = .clear
            monthHeaderView.appearance = appereance
        }
    }
    
    @IBOutlet weak var weekDaysView: VAWeekDaysView! {
        didSet {
            let appereance = VAWeekDaysViewAppearance(symbolsType: .veryShort, weekDayTextColor: .black, weekDayTextFont: UIFont.boldSystemFont(ofSize: 14.0), calendar: defaultCalendar)
            weekDaysView.appearance = appereance
        }
    }
    
    lazy var dateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd"
        return df
    }()
    
    var calendarView: VACalendarView!
    
    
    var viewModel = SchedulesViewModel()
    
    var selectedDate: Date = Date()
    var selectedMonth = 0
    var selectedYear = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addNotoficationObserver()
        setupNavigation()
        setupView()
        self.setupGestureForSideMene()
        self.selectedDateStr = Date().getFormattedDate(format: "yyyy-MM-dd")
        let cdate = Date()
        let strdate = dateFormatter.string(from: cdate)
        let month = cdate.month
        let year = cdate.year
        navigationItem.title = year
        selectedMonth = Int(month) ?? 0
        selectedYear = Int(year) ?? 0
        getSchedulesFor(month: month, year: year)

        if cdate.nameOfDay != "Saturday" && cdate.nameOfDay != "Sunday" {
            getSchedulesFor(date: strdate)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    func setupNavigation() {
        navigationController?.setTransparentNavigationBar()
    }
    
    func setupView() {
        let calendar = VACalendar(calendar: defaultCalendar)
        
        calendarView = VACalendarView(frame: .zero, calendar: calendar)
        calendarView.showDaysOut = true
        calendarView.selectionStyle = .single
        calendarView.monthDelegate = monthHeaderView
        calendarView.dayViewAppearanceDelegate = self
        calendarView.monthViewAppearanceDelegate = self
        calendarView.calendarDelegate = self
        calendarView.scrollDirection = .horizontal        
        view.addSubview(calendarView)
        
        tableViewList.estimatedRowHeight = 100
        tableViewList.rowHeight = UITableView.automaticDimension
        viewListContainer.backgroundColor = COLOR_LIGHT_ORANGE
        viewTopLine.setCornerRadius(3, borderWidth: 0, borderColor: .clear)
        
        let cdate = Date()
        let strdate = dateFormatter.string(from: cdate)
        getSchedulesFor(date: strdate)
        self.selectedDateStr = Date().getFormattedDate(format: "yyyy-MM-dd")
        self.tableViewList.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0)
        
    }
   
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if calendarView.frame == .zero {
            calendarView.frame = CGRect(
                x: 48,
                y: weekDaysView.frame.maxY,
                width: view.frame.width-96,
                height: 250
            )
            calendarView.setup()
        }
        
        viewListContainer.roundCorners(corners: [.topLeft, .topRight], radius: 35.0)
    }
    func addNotoficationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(createSchedulePopUpPreset), name: .createSchedulePopUpPreset, object: nil)
    }
    @IBAction func btnCellMenuClicked(_ sender:UIButton) {
        self.setupMenuDropDown(sender)
        menuDropDown.show()
    }
    
    @IBAction func btnAddScheduleClicked(_ sender: Any) {
        let vc = SelectGroupsVC.instantiate(fromStoryboard: .main)
        vc.isToSchedule = true
        self.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func createSchedulePopUpPreset(notfication: NSNotification) {
        guard let dict = notfication.userInfo,
            let arrID = dict["StudentIDs"] as? [Int],
            let groupId = dict["groupId"] as? Int,
            let stopId = dict["stopID"] as? Int
            else { return}
        self.presetntCreateScheduleVC(arrID: arrID, groupId: groupId, stopId: stopId)
    }
    
    @IBAction func switchChanged(sender: UISwitch) {
        self.isSupervisor = !self.isSupervisor
        let strdate = dateFormatter.string(from: selectedDate)
        getSchedulesFor(date: strdate)
        getSchedulesFor(month: "\(selectedMonth)", year: "\(selectedYear)")
        calendarView.assignedDates([])
    }
    
    func getSchedulesFor(date: String) {
        CommonFunctions.showHUDOnTop()
        let isSupervisor = switchSupervisor.isOn
        viewModel.getScheduleFor(date: date, isSupervisor: isSupervisor) { (status, message) in
            DispatchQueue.main.async {
                CommonFunctions.hideHUDFromTop()
            }
            if status {
                self.tableViewList.reloadData()
                self.updateDatesOnCalendar()
                self.calendarView.selectDates([self.selectedDate])
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
    
    func presetntCreateScheduleVC(arrID:[Int], groupId:Int,stopId:Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let vc = CreateScheduleVC.instantiate(fromStoryboard: .schedule)
            vc.arrStudentID = arrID
            vc.selectedDayName = self.selectedDate.nameOfDay
            vc.groupId = String(format: "%d", groupId)
            vc.stopId = String(format: "%d", stopId)
            vc.isSupervisor = self.isSupervisor
            vc.selectedDate = self.selectedDateStr
            vc.modalPresentationStyle = .overCurrentContext
            vc.doneCreateSchedule = { message in
                let successVC = SchecduleSuccessPopUpVC.instantiate(fromStoryboard: .schedule)
                successVC.message = message ?? ""
                successVC.btnDoneClicked = {
                    self.getSchedulesFor(date: self.selectedDateStr)
                    self.getSchedulesFor(month: "\(self.selectedMonth)", year: "\(self.selectedYear)")
                }
                successVC.modalPresentationStyle = .overCurrentContext
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.present(successVC, animated: true, completion: nil)
                }
            }
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func setupMenuDropDown(_ sender:UIButton) {
        menuDropDown.anchorView = sender
        menuDropDown.bottomOffset = CGPoint(x: 0, y: sender.frame.size.height )
        let arrStr = ["View", "Edit Schedule", "Delete Schedule"]
        var arrDataSource = [DropDownDataModel]()
        for str in arrStr {
            let dataModel2 = DropDownDataModel()
            dataModel2.item = str
            dataModel2.dataObject = sender.tag as AnyObject
            arrDataSource.append(dataModel2)
        }
        menuDropDown.dataSource = arrDataSource
        menuDropDown.selectionAction = {[weak self] (index, item) in
            switch index {
            case 0:
                self?.btnViewGroupDetailClicked(index: item.dataObject as? Int ?? 0)
            case 1:
                self?.presetntEditScheduleVC(index: item.dataObject as? Int ?? 0)
            case 2:
                let actionYes : [String: () -> Void] = [ "YES" : {
                    guard let row = item.dataObject as? Int,  let scheduleD = self?.viewModel.getSchedule(at: row) else { return }
                    self?.deleteSchedule(schedule: scheduleD)
                }]
                let actionNo : [String: () -> Void] = [ "No" : {
                    print("tapped NO")
                }]
                let arrayActions = [actionYes, actionNo]
                self?.showCustomAlertWith (
                    message: "Are you sure you want to delete your schedule?",
                    descMsg: "",
                    itemimage: nil,
                    actions: arrayActions
                )
            default:
                break
            }
        }
    }
    
    func deleteSchedule(schedule:Schedule) {
        self.viewModel.callWebServiceToDeleteSchedule(tripId: schedule.tripId ?? 0, studentId: schedule.studentId ?? 0, isSupervisor: self.switchSupervisor.isOn, completion: { (status, message) in
            if status || message == "Schedule has been deleted successfully!"{
                let strdate = self.dateFormatter.string(from:  self.selectedDate)
                self.getSchedulesFor(date: strdate)
            } else {
                self.showCustomAlertWith(
                    message: message,
                    descMsg: "",
                    itemimage: nil,
                    actions: nil
                )
            }
        })
    }
    func btnViewGroupDetailClicked(index:Int) {
        guard let schedule = viewModel.getSchedule(at: index) else { return }
        let vc = GroupDetailVC.instantiate(fromStoryboard: .groups)
        vc.groupId = schedule.groupId ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
    func presetntEditScheduleVC(index:Int) {
        guard let schedule = viewModel.getSchedule(at: index) else { return }
        let vc = EditScheduleVC.instantiate(fromStoryboard: .schedule)
        vc.studentID = schedule.studentId ?? 0
        vc.stopId = schedule.stopId ?? 0
        vc.stopName = schedule.stopName ?? ""
        vc.isSupervisor = self.isSupervisor
        vc.oldSelectedDate = self.selectedDateStr
        vc.tripId = schedule.tripId ?? 0
        vc.routeId = schedule.routeId ?? 0
        vc.modalPresentationStyle = .overFullScreen
        vc.doneEditSchedule = { oldSelectedDate in
            self.getSchedulesFor(date: oldSelectedDate)
        }
        self.present(vc, animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.prepareSideMenu(segue: segue)
    }
    
    func getSchedulesFor(month: String, year: String) {
        let isSupervisor = switchSupervisor.isOn
        let monthName = Int(month)?.getMonthNameFromNumber() ?? ""
        viewModel.getScheduleFor(month: monthName, year: year, isSupervisor: isSupervisor) { (status, message) in
            if status {
                self.updateDatesOnCalendar()
            }
        }
    }
    
    func updateDatesOnCalendar() {
        
        if let data = viewModel.monthResponse?.data {
            var arrayDates = [Date]()
            for schedue in data {
                let date = dateFormatterServer.date(from: schedue.dueOn!)
                arrayDates.append(date!)
            }
            if arrayDates.count > 0 {
                calendarView.assignedDates(arrayDates)
            } else {
                calendarView.assignedDates([])
            }
        }
    }
}

extension ScheduleVC: VAMonthHeaderViewDelegate {
    
    func didTapNextMonth() {
        let endDate = Calendar.current.date(byAdding: .year, value: 5, to: Date())!
        if "\(selectedYear)" == endDate.year && "\(selectedMonth+1)" == endDate.month {
            return
        }
        
        calendarView.nextMonth()
        if selectedMonth == 12 {
            selectedYear += 1
            selectedMonth = 1
        } else {
            selectedMonth += 1
        }
        
        getSchedulesFor(month: "\(selectedMonth)", year: "\(selectedYear)")
        navigationItem.title = "\(selectedYear)"
    }
    
    func didTapPreviousMonth() {
        let startDate = Calendar.current.date(byAdding: .year, value: 0, to: Date())!
        if "\(selectedYear)" == startDate.year && "\(selectedMonth)" == startDate.month {
            return
        }
        calendarView.previousMonth()
        if selectedMonth == 1 {
            selectedYear -= 1
            selectedMonth = 12
        } else {
            selectedMonth -= 1
        }
        getSchedulesFor(month: "\(selectedMonth)", year: "\(selectedYear)")
        navigationItem.title = "\(selectedYear)"
    }
}

extension ScheduleVC: VAMonthViewAppearanceDelegate {
    func leftInset() -> CGFloat {
        return 5
    }
    
    func rightInset() -> CGFloat {
        return 5
    }
}

extension ScheduleVC: VADayViewAppearanceDelegate {
    
    func textColorForToday() -> UIColor {
        return COLOR_33_43_54_100
    }
    
    func backgroundColorForToday() -> UIColor {
        return .clear
    }
    
    func font(for state: VADayState) -> UIFont {
        switch state {
        case .out:
            return UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        case .selected:
            return UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        case .unavailable:
            return UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        default:
            return UIFont(name: "HelveticaNeue-Light", size: 14.0)!
        }
    }
    
    func textColor(for state: VADayState) -> UIColor {
        switch state {
        case .out:
            return COLOR_33_43_54_30
        case .selected:
            return COLOR_PRIMARY_WHITE
        case .unavailable:
            return COLOR_33_43_54_30
        case .assigned:
            return COLOR_PRIMARY_ORANGE
        default:
            return COLOR_33_43_54_100
        }
    }
    
    func textBackgroundColor(for state: VADayState) -> UIColor {
        switch state {
        case .selected:
            return COLOR_PRIMARY_ORANGE
        default:
            return .clear
        }
    }
    
    func shape() -> VADayShape {
        return .square
    }
    
    func dotBottomVerticalOffset(for state: VADayState) -> CGFloat {
        switch state {
        case .selected:
            return 2
        default:
            return -7
        }
    }
    
}

extension ScheduleVC: VACalendarViewDelegate {

    func selectedDate(_ date: Date) {
        selectedDate = date
        let strdate = dateFormatter.string(from: date)
        getSchedulesFor(date: strdate)
        if (date.distance(from: Date(), only: Calendar.Component.day) == 0) {
            self.btnAddSchedule.isHidden = false
        }else{
            self.btnAddSchedule.isHidden = ((date < Date()) || date.isWeekend)
        }
        if date.isWeekend{
            self.btnAddSchedule.isHidden = true
        }
        self.selectedDateStr = date.getFormattedDate(format: "yyyy-MM-dd")
        print(date)
    }
    
}

extension ScheduleVC: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let viewHeader = UIView(frame: CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0))
        viewHeader.backgroundColor = COLOR_LIGHT_ORANGE
        
        let label = UILabel(frame: CGRect(x: 30, y: 10, width: SCREEN_WIDTH - 100, height: 26))
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 16.0)
        label.textColor = COLOR_DARK_BLUE_GRAY
        viewHeader.addSubview(label)
                        
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        let str = df.string(from: selectedDate)
        label.text = str.uppercased()
        if selectedDate.nameOfDay == "Saturday" || selectedDate.nameOfDay == "Sunday" {
            label.text = ""
        }
        return viewHeader
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        errorlabel.isHidden = viewModel.scheduleCount != 0
        return viewModel.scheduleCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ActivityCell") as! ActivityCell
        if let schedule = viewModel.getSchedule(at: indexPath.row) {
            if switchSupervisor.isOn {
                cell.labelStudent.isHidden = true
                cell.stackViewSupervisor.isHidden = false
            } else {
                cell.labelStudent.isHidden = false
                cell.stackViewSupervisor.isHidden = true
            }
            cell.btnCellMenu.tag = indexPath.row
            cell.labelTime.text = (schedule.displayTime ?? "").uppercased()
            cell.labelTitle.text = schedule.groupName ?? ""
            cell.labelStudent.text = "Student: \(schedule.studentName ?? "")"
            cell.labelSupervisor.text = "Supervisor: \(schedule.supervisorName ?? "")"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}



