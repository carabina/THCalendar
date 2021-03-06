//
//  AppDelegate.swift
//  calendar
//
//  Created by thierryH24 on 12/10/2017.
//  Copyright © 2017 thierryH24. All rights reserved.
//

import Cocoa


class THCalendarView: NSViewController {
    
    @IBOutlet weak var collectionView: NSCollectionView!

    public struct Preferences {
        
        public struct Calendar {
            public var textColor = NSColor.black.withAlphaComponent(0.3)
            public var cellColorDefault = NSColor(white: 0.0, alpha: 0.1)
            public var cellColorToday = #colorLiteral(red: 0.996078431372549, green: 0.286274509803922, blue: 0.250980392156863, alpha: 0.3)
            public var borderColor = #colorLiteral(red: 0.996078431372549, green: 0.286274509803922, blue: 0.250980392156863, alpha: 0.8)
            public var backgroundColors = #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1)
            public var beginWeek : weekDisplay = .monday
        }
        
        public struct Date {
            public var circleBackgroundColor = NSColor.red
            public var dotColor = NSColor.blue
        }
        
        var calendar = Calendar()
        var date = Date()
        
        public init() {}
    }
    
    enum weekDisplay : Int {
        
        case sunday = 6
        case monday = 5
        case tuesday = 4
        case wednesday = 3
        case thursday = 2
        case friday = 1
        case saturday = 0
    }
    
    public static var globalPreferences = Preferences()
    
    // Today
    var date = Date()
    // Selected Date
    public var selectedDate: Date = Date() {
        didSet {
            selectSelectedDateItem()
        }
    }
    
    public var counts: [Int]?
    
    enum Section: Int {
        case month = 0, week, date
    }
    
    public init() {
        super.init(nibName: NSNib.Name(rawValue: "THCalendarView"), bundle: Bundle(for: THCalendarView.self))
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let colorBackGround = THCalendarView.globalPreferences.calendar.backgroundColors
        collectionView.backgroundColors =  [colorBackGround]

    }
    
    
    override func viewWillLayout() {
        super.viewWillLayout()
        
        // When we're invalidating the collection view layout
        // it will call `collectionView(_:layout:sizeForItemAt:)` method
        collectionView.collectionViewLayout?.invalidateLayout()
        collectionView.reloadData()
    }
        
    func selectSelectedDateItem() {
//        if let selectedIndexPath = indexPathForDate(selectedDate: selectedDate) {
//            collectionView?.selectItems(at: [selectedIndexPath ], scrollPosition: [.top])
//        }
    }
    
    func indexPathForDate(selectedDate: Date) -> IndexPath? {
        
        let calendar = Calendar.current

        if calendar.month(date) == calendar.month(selectedDate) {
            let start = date.startOfMonth()
            let weekDay = calendar.component(.weekday, from: start)
            
            let item = weekDay + calendar.day(selectedDate) - 2
            let index = IndexPath(item: item, section: Section.date.rawValue)
            return index
        }
        return nil
    }
    
    
    @IBAction func previousMonth(_ sender: Any) {
        goToMonthWithOffet(-1)
    }
    
    @IBAction func toDayMonth(_ sender: Any) {
    
        self.date = Date()
        selectedDate = Date()
        
        collectionView.reloadData()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        goToMonthWithOffet(1)
    }
    
    func goToMonthWithOffet(_ offet:Int){
        
        if let newDate = (date.applyOffSetOfMonth( offset: offet)){
            date = newDate
            selectedDate = newDate
            collectionView.reloadData()
        }
    }

}

extension THCalendarView: NSCollectionViewDelegate {
    
}

extension THCalendarView: NSCollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> NSSize {
        
        let width = collectionView.bounds.width
        var size = NSSize()
        
        switch Section(rawValue: indexPath.section)! {
        case .month:
            size =  NSMakeSize(width, 50)
        case .week:
            size = NSMakeSize(width / 7, 30)
        case .date:
            size = NSMakeSize(width / 7, 50 )
        }
        return size
    }
}

extension Date {
    
    func applyOffSetOfMonth( offset:Int) -> Date? {
        
        var dateComponents = DateComponents()
        dateComponents.month = offset
        
        return Calendar.current.date(  byAdding: dateComponents, to: self, wrappingComponents: false)
    }
}

