//
//  TwoButtonSegmentView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 12/5/25.
//

import UIKit
import HorizonCalendar


// MARK: - DemoViewController

protocol DemoViewController: UIViewController {

  init(monthsLayout: MonthsLayout)

  var calendar: Calendar { get }
  var monthsLayout: MonthsLayout { get }

}

// MARK: - BaseDemoViewController

class BaseDemoViewController: UIViewController, DemoViewController {

  // MARK: Lifecycle

  required init(monthsLayout: MonthsLayout) {
    self.monthsLayout = monthsLayout

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  let monthsLayout: MonthsLayout

  lazy var calendarView = CalendarView(initialContent: makeContent())
  lazy var calendar = Calendar.current
  lazy var dayDateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.calendar = calendar
    dateFormatter.locale = calendar.locale
    dateFormatter.dateFormat = DateFormatter.dateFormat(
      fromTemplate: "EEEE, MMM d, yyyy",
      options: 0,
      locale: calendar.locale ?? Locale.current)
    return dateFormatter
  }()

  override func viewDidLoad() {
    super.viewDidLoad()

    view.backgroundColor = .systemBackground

    view.addSubview(calendarView)

    calendarView.translatesAutoresizingMaskIntoConstraints = false
    switch monthsLayout {
    case .vertical:
      NSLayoutConstraint.activate([
        calendarView.topAnchor.constraint(equalTo: view.topAnchor),
        calendarView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        calendarView.leadingAnchor.constraint(
          greaterThanOrEqualTo: view.layoutMarginsGuide.leadingAnchor),
        calendarView.trailingAnchor.constraint(
          lessThanOrEqualTo: view.layoutMarginsGuide.trailingAnchor),
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 375),
        calendarView.widthAnchor.constraint(equalToConstant: 375).prioritize(at: .defaultLow),
      ])
    case .horizontal:
      NSLayoutConstraint.activate([
        calendarView.centerYAnchor.constraint(equalTo: view.layoutMarginsGuide.centerYAnchor),
        calendarView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor),
        calendarView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor),
        calendarView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        calendarView.widthAnchor.constraint(lessThanOrEqualToConstant: 375),
        calendarView.widthAnchor.constraint(equalToConstant: 375).prioritize(at: .defaultLow),
      ])
    }
  }

  func makeContent() -> CalendarViewContent {
    fatalError("Must be implemented by a subclass.")
  }

}

// MARK: NSLayoutConstraint + Priority Helper

extension NSLayoutConstraint {

  fileprivate func prioritize(at priority: UILayoutPriority) -> NSLayoutConstraint {
    self.priority = priority
    return self
  }

}




final class DayRangeIndicatorView: UIView {

  // MARK: Lifecycle

  fileprivate init(indicatorColor: UIColor) {
    self.indicatorColor = indicatorColor

    super.init(frame: .zero)

    backgroundColor = .clear
  }

  required init?(coder _: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Internal

  override func draw(_: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    context?.setFillColor(indicatorColor.cgColor)

    if traitCollection.layoutDirection == .rightToLeft {
      context?.translateBy(x: bounds.midX, y: bounds.midY)
      context?.scaleBy(x: -1, y: 1)
      context?.translateBy(x: -bounds.midX, y: -bounds.midY)
    }

    // Get frames of day rows in the range
    var dayRowFrames = [CGRect]()
    var currentDayRowMinY: CGFloat?
    for dayFrame in framesOfDaysToHighlight {
      if dayFrame.minY != currentDayRowMinY {
        currentDayRowMinY = dayFrame.minY
        dayRowFrames.append(dayFrame)
      } else {
        let lastIndex = dayRowFrames.count - 1
        dayRowFrames[lastIndex] = dayRowFrames[lastIndex].union(dayFrame)
      }
    }

    // Draw rounded rectangles for each day row
    for dayRowFrame in dayRowFrames {
      let cornerRadius = dayRowFrame.height / 2
      let roundedRectanglePath = UIBezierPath(roundedRect: dayRowFrame, cornerRadius: cornerRadius)
      context?.addPath(roundedRectanglePath.cgPath)
      context?.fillPath()
    }
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    setNeedsDisplay()
  }

  // MARK: Fileprivate

  fileprivate var framesOfDaysToHighlight = [CGRect]() {
    didSet {
      guard framesOfDaysToHighlight != oldValue else { return }
      setNeedsDisplay()
    }
  }

  // MARK: Private

  private let indicatorColor: UIColor

}
//
//// MARK: CalendarItemViewRepresentable
//
extension DayRangeIndicatorView: CalendarItemViewRepresentable {

  struct InvariantViewProperties: Hashable {
      var indicatorColor = UIColor.orange.withAlphaComponent(0.3)
  }

  struct Content: Equatable {
    let framesOfDaysToHighlight: [CGRect]
  }

  static func makeView(
    withInvariantViewProperties invariantViewProperties: InvariantViewProperties)
    -> DayRangeIndicatorView
  {
    DayRangeIndicatorView(indicatorColor: invariantViewProperties.indicatorColor)
  }

  static func setContent(_ content: Content, on view: DayRangeIndicatorView) {
    view.framesOfDaysToHighlight = content.framesOfDaysToHighlight
  }

}



import UIKit
import HorizonCalendar

final class DayRangeSelectionDemoViewController: BaseDemoViewController {

    // MARK: - UI Elements
    private var selectedDayRange: DayComponentsRange?
    private var selectedDayRangeAtStartOfDrag: DayComponentsRange?

    // Add the submit button
    private let submitButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Submit", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isEnabled = false
        button.alpha = 0.5 // visually indicate disabled
        return button
    }()



    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Day Range Selection"

        // Set up calendar view handlers
        calendarView.daySelectionHandler = { [weak self] day in
            guard let self else { return }

            print("daySelectionHandler day === > \(day)")

            DayRangeSelectionHelper.updateDayRange(
                afterTapSelectionOf: day,
                existingDayRange: &selectedDayRange)

            calendarView.setContent(makeContent())
            self.updateSubmitButtonState()
        }

        calendarView.multiDaySelectionDragHandler = { [weak self, calendar] day, state in
            guard let self else { return }

            print("multiDaySelectionDragHandler day === > \(calendar) === > \(day) === > \(state)")

            DayRangeSelectionHelper.updateDayRange(
                afterDragSelectionOf: day,
                existingDayRange: &selectedDayRange,
                initialDayRange: &selectedDayRangeAtStartOfDrag,
                state: state,
                calendar: calendar)

            calendarView.setContent(makeContent())
            if state == .ended {
                self.updateSubmitButtonState()
            }
        }

        // Add the submit button to the view
        view.addSubview(submitButton)
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)

    
        // Add constraints for the submit button
        NSLayoutConstraint.activate([
            submitButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }



    override func makeContent() -> CalendarViewContent {
        let calendar = Calendar.current
        let currentDate = Date()

        // Start of the visible date range: January 1, 2020
        let startOfVisible = calendar.date(from: DateComponents(year: 2020, month: 1, day: 1))!

        // End of the visible date range: current date
        let endOfVisible = currentDate

        // Create date ranges from selectedDayRange
        let dateRanges: Set<ClosedRange<Date>>
        if let selectedDayRange = selectedDayRange,
           let lowerBound = calendar.date(from: selectedDayRange.lowerBound.components),
           let upperBound = calendar.date(from: selectedDayRange.upperBound.components) {
            dateRanges = [lowerBound...upperBound]
        } else {
            dateRanges = []
        }

        return CalendarViewContent(
            calendar: calendar,
            visibleDateRange: startOfVisible...endOfVisible, // Set visible range from 2020 to current date
            monthsLayout: monthsLayout
        )
        .interMonthSpacing(24)
        .verticalDayMargin(8)
        .horizontalDayMargin(8)
        .dayItemProvider { [self, calendar, dayDateFormatter] day in
            var invariantViewProperties = DayView.InvariantViewProperties.baseInteractive

            let isSelectedStyle = day == selectedDayRange?.lowerBound || day == selectedDayRange?.upperBound

            if isSelectedStyle {
                invariantViewProperties.backgroundShapeDrawingConfig.fillColor =  UIColor.orange//.systemBackground
                invariantViewProperties.backgroundShapeDrawingConfig.borderColor = UIColor.orange //UIColor.systemBlue
            }

            let date = calendar.date(from: day.components)

            return DayView.calendarItemModel(
                invariantViewProperties: invariantViewProperties,
                content: .init(
                    dayText: "\(day.day)",
                    accessibilityLabel: date.map { dayDateFormatter.string(from: $0) },
                    accessibilityHint: nil))
        }
        .dayRangeItemProvider(for: dateRanges) { dayRangeLayoutContext in
            DayRangeIndicatorView.calendarItemModel(
                invariantViewProperties: .init(),
                content: .init(
                    framesOfDaysToHighlight: dayRangeLayoutContext.daysAndFrames.map { $0.frame }))
        }
    }


    // MARK: - Submit Button Action

    private func updateSubmitButtonState() {
        guard let range = selectedDayRange else {
            submitButton.isEnabled = false
            submitButton.alpha = 0.5
            return
        }

        if range.lowerBound != range.upperBound {
            submitButton.isEnabled = true
            submitButton.alpha = 1.0
        } else {
            submitButton.isEnabled = false
            submitButton.alpha = 0.5
        }
    }

    
    
    @objc private func handleSubmit() {
        guard let selectedDayRange = selectedDayRange else { return }

        let calendar = Calendar.current
        if let startDate = calendar.date(from: selectedDayRange.lowerBound.components),
           let endDate = calendar.date(from: selectedDayRange.upperBound.components) {

            let startTimestamp = Int(startDate.currentTimeMillis())
            let endTimestamp = Int(endDate.currentTimeMillis())

            let formatter = DateFormatter()
            formatter.timeZone = .current
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // Or just "yyyy-MM-dd" if preferred

            print("✅ Submit tapped")
            print("Start Date: \(formatter.string(from: startDate)) → Timestamp: \(startTimestamp)")
            print("End Date: \(formatter.string(from: endDate)) → Timestamp: \(endTimestamp)")
        }
    }
    
}

enum DayRangeSelectionHelper {
    static func updateDayRange(
        afterTapSelectionOf day: DayComponents,
        existingDayRange: inout DayComponentsRange?) {
        if let _existingDayRange = existingDayRange,
           _existingDayRange.lowerBound == _existingDayRange.upperBound,
           day > _existingDayRange.lowerBound {
            existingDayRange = _existingDayRange.lowerBound...day
        } else {
            existingDayRange = day...day
        }
    }

    static func updateDayRange(
        afterDragSelectionOf day: DayComponents,
        existingDayRange: inout DayComponentsRange?,
        initialDayRange: inout DayComponentsRange?,
        state: UIGestureRecognizer.State,
        calendar: Calendar) {
        switch state {
        case .began:
            if day != existingDayRange?.lowerBound, day != existingDayRange?.upperBound {
                existingDayRange = day...day
            }
            initialDayRange = existingDayRange

        case .changed, .ended:
            guard let initialDayRange else { return }

            let startingLowerDate = calendar.date(from: initialDayRange.lowerBound.components)!
            let startingUpperDate = calendar.date(from: initialDayRange.upperBound.components)!
            let selectedDate = calendar.date(from: day.components)!

            let numberOfDaysToLowerDate = calendar.dateComponents([.day], from: selectedDate, to: startingLowerDate).day!
            let numberOfDaysToUpperDate = calendar.dateComponents([.day], from: selectedDate, to: startingUpperDate).day!

            if abs(numberOfDaysToLowerDate) < abs(numberOfDaysToUpperDate) || day < initialDayRange.lowerBound {
                existingDayRange = day...initialDayRange.upperBound
            } else if abs(numberOfDaysToLowerDate) > abs(numberOfDaysToUpperDate) || day > initialDayRange.upperBound {
                existingDayRange = initialDayRange.lowerBound...day
            }

        default:
            existingDayRange = nil
            initialDayRange = nil
        }
    }
    
}


