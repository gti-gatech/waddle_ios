//
//  VADay.swift
//  VACalendar
//
//  Created by Anton Vodolazkyi on 20.02.18.
//  Copyright © 2018 Vodolazkyi. All rights reserved.
//

import UIKit

@objc
public enum VADayState: Int {
    case out, selected, available, unavailable, assigned, assignedAndSelected, disabled
}

@objc
public enum VADayShape: Int {
    case square, circle
}

public enum VADaySupplementary: Hashable {
    
    // 3 dot max
    case bottomDots([UIColor])
    
    public var hashValue: Int {
        switch self {
        case .bottomDots:
            return 1
        }
    }
    
    public static func ==(lhs: VADaySupplementary, rhs: VADaySupplementary) -> Bool {
        return lhs.hashValue == rhs.hashValue
    }
}

class VADay {
    
    let date: Date
    var stateChanged: ((VADayState) -> Void)?
    var supplementariesDidUpdate: (() -> Void)?
    let calendar: Calendar
    
    var isToday: Bool {
        return calendar.isDateInToday(date)
    }

    var reverseSelectionState: VADayState {
        return state == .available ? .selected : .available
    }
    
    var isSelected: Bool {
        return state == .selected
    }
    
    var isAssigned: Bool {
        return state == .assigned
    }
    
    var isSelectable: Bool {
        return state == .selected || state == .available
    }
    
    var dayInMonth: Bool {
        return state != .out
    }
    
    var state: VADayState {
        didSet {
            stateChanged?(state)
        }
    }
    
    var supplementaries = Set<VADaySupplementary>() {
        didSet {
            supplementariesDidUpdate?()
        }
    }
    
    init(date: Date, state: VADayState, calendar: Calendar) {
        self.date = date
        self.state = state
        self.calendar = calendar
    }
    
    func dateInDay(_ date: Date) -> Bool {
        return calendar.isDate(date, equalTo: self.date, toGranularity: .day)
    }
    
    func setSelectionState(_ state: VADayState) {
        if (self.state == .selected && state == .assigned) {
            return
        }
        
        if state == .assigned || state == .assignedAndSelected || state == .selected || state == .disabled {
            self.state = state
        } else {
            guard state == reverseSelectionState && isSelectable  else { return }
            self.state = state
        }
    }
    
    func setState(_ state: VADayState) {
        self.state = state
    }
    
    func set(_ supplementaries: [VADaySupplementary]) {
        self.supplementaries = Set(supplementaries)
    }
    
}

extension VADay: Comparable {
    
    static func <(lhs: VADay, rhs: VADay) -> Bool {
        return !lhs.dateInDay(rhs.date)
    }
    
    static func ==(lhs: VADay, rhs: VADay) -> Bool {
        return lhs.dateInDay(rhs.date)
    }
    
}
