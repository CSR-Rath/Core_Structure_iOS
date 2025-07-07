//
//  CustomDatePickerView.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 6/6/25.
//

import UIKit

class CustomDatePickerViewController: UIViewController{
    
    let datePicker = CustomDatePickerView()
    
    override func loadView() {
        super.loadView()
        view = datePicker
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

class CustomDatePickerView: UIView {
    
    private var collectionView: UICollectionView!
    private var currentDate = Date()
    private var daysInMonth: [Date] = []
    
    private var startDate: Date?
    private var endDate: Date?
    
    private let headerLabel = UILabel()
    private let submitButton = UIButton(type: .system)
    private let weekdaysStackView = UIStackView()
    
    private let months = Array(1...12)
    private let years = Array(1900...2100)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupHeader()
        setupWeekdaysHeader()
        setupCollectionView()
        setupSubmitButton()
        loadDaysInMonth(for: currentDate)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupHeader() {
        let headerStack = UIStackView()
        headerStack.axis = .horizontal
        headerStack.alignment = .center
        headerStack.distribution = .equalCentering
        headerStack.spacing = 50
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        let prevButton = UIButton(type: .system)
        prevButton.setTitle("<", for: .normal)
        prevButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        prevButton.addTarget(self, action: #selector(showPreviousMonth), for: .touchUpInside)
        
        let nextButton = UIButton(type: .system)
        nextButton.setTitle(">", for: .normal)
        nextButton.titleLabel?.font = .boldSystemFont(ofSize: 20)
        nextButton.addTarget(self, action: #selector(showNextMonth), for: .touchUpInside)
        
        let nextButtonLeft = UIButton(type: .system)
        nextButtonLeft.setTitle(">", for: .normal)
        
        let yearStack = UIStackView()
        yearStack.axis = .horizontal
        yearStack.alignment = .center
        yearStack.distribution = .equalCentering
        yearStack.spacing = 5
        yearStack.translatesAutoresizingMaskIntoConstraints = false
        yearStack.addArrangedSubview(headerLabel)
        yearStack.addArrangedSubview(nextButtonLeft)
        
        headerLabel.font = .boldSystemFont(ofSize: 18)
        headerLabel.textAlignment = .center
        headerLabel.isUserInteractionEnabled = true
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showMonthYearPicker))
        headerLabel.addGestureRecognizer(tapGesture)
        
        updateHeaderLabel()
        
        headerStack.addArrangedSubview(prevButton)
        headerStack.addArrangedSubview(nextButton)
        
        addSubview(headerStack)
        addSubview(yearStack)
        
        NSLayoutConstraint.activate([
            
            headerStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 30),
            headerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            headerStack.heightAnchor.constraint(equalToConstant: 40),
            
            headerLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            headerLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16),
            
        ])
    }
    
    private func setupWeekdaysHeader() {
        weekdaysStackView.axis = .horizontal
        weekdaysStackView.distribution = .fillEqually
        weekdaysStackView.alignment = .center
        weekdaysStackView.translatesAutoresizingMaskIntoConstraints = false
        weekdaysStackView.isLayoutMarginsRelativeArrangement = true
        weekdaysStackView.layoutMargins = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        let weekdaySymbols = ["Mon".localizeString(),
                              "Tue".localizeString(),
                              "Wed".localizeString(),
                              "Thu".localizeString(),
                              "Fri".localizeString(),
                              "Sat".localizeString(),
                              "Sun".localizeString()
        ]
        
        for day in weekdaySymbols {
            let label = UILabel()
            label.text = day
            label.font = .systemFont(ofSize: 14, weight: .medium)
            label.textAlignment = .center
            weekdaysStackView.addArrangedSubview(label)
        }
        
        addSubview(weekdaysStackView)
        
        NSLayoutConstraint.activate([
            weekdaysStackView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30),
            weekdaysStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            weekdaysStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            weekdaysStackView.heightAnchor.constraint(equalToConstant: 30)
        ])
        
    }
    
    private func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        let screenWidth: CGFloat = UIScreen.main.bounds.width - 100
        
        let itemSize = screenWidth / 7
        
        print("screenWidth ==> \(screenWidth)")
        print("itemSize ==> \(itemSize)")
        print("itemSize ==> \(itemSize * 7)")
        
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateCell.self, forCellWithReuseIdentifier: "DateCell")
        
        addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: weekdaysStackView.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor,constant: 0),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor,constant: 0),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    private func setupSubmitButton() {
        submitButton.setTitle("Submit", for: .normal)
        submitButton.setTitleColor(.white, for: .normal)
        submitButton.backgroundColor = .systemBlue
        submitButton.layer.cornerRadius = 10
        submitButton.translatesAutoresizingMaskIntoConstraints = false
        submitButton.addTarget(self, action: #selector(handleSubmit), for: .touchUpInside)
        
        addSubview(submitButton)
        
        NSLayoutConstraint.activate([
            submitButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            submitButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            submitButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            submitButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
    }
    
    @objc private func handleSubmit() {
        
        guard let start = startDate else {
            print("Please select a start date.")
            return
        }
        guard let end = endDate else {
            print("Please select an end date.")
            return
        }
        if start > end {
            print("Start date cannot be later than end date.")
            return
        }
        
        // Format with local timezone
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.timeZone = TimeZone.current //(identifier: "Asia/Phnom_Penh") // or .current
        print("✅ Selected range: \(formatter.string(from: start)) to \(formatter.string(from: end))")
    }
    
    
    private func loadDaysInMonth(for date: Date) {
        daysInMonth.removeAll()
        let calendar = Calendar.current
        
        guard let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date)),
              let range = calendar.range(of: .day, in: .month, for: date) else { return }
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        // Calculate leading empty days based on Monday = 2 in Gregorian calendar
        // Adjust so Monday = 0 empty slots
        let leadingEmptyDays = (firstWeekday + 5) % 7  // (weekday - 2 + 7) % 7
        
        for _ in 0..<leadingEmptyDays {
            daysInMonth.append(Date.distantPast) // Placeholder for empty days
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                daysInMonth.append(date)
            }
        }
        
        collectionView.reloadData()
    }
    
    private func updateHeaderLabel() {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        formatter.timeZone = TimeZone.current
        headerLabel.text = formatter.string(from: currentDate)
    }
    
    @objc private func showPreviousMonth() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: -1, to: currentDate) else { return }
        currentDate = newDate
        updateHeaderLabel()
        loadDaysInMonth(for: currentDate)
    }
    
    @objc private func showNextMonth() {
        guard let newDate = Calendar.current.date(byAdding: .month, value: 1, to: currentDate) else { return }
        currentDate = newDate
        updateHeaderLabel()
        loadDaysInMonth(for: currentDate)
    }
    
    @objc private func showMonthYearPicker() {
        let alert = UIAlertController(title: "\n\n\n\n\n\n", message: nil, preferredStyle: .alert)
        let picker = UIPickerView(frame: CGRect(x: 0, y: 10, width: 300, height: 150))
        picker.dataSource = self
        picker.delegate = self
        
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: currentDate)
        let currentYear = calendar.component(.year, from: currentDate)
        
        if let monthIndex = months.firstIndex(of: currentMonth),
           let yearIndex = years.firstIndex(of: currentYear) {
            picker.selectRow(monthIndex, inComponent: 0, animated: false)
            picker.selectRow(yearIndex, inComponent: 1, animated: false)
        }
        
        alert.view.addSubview(picker)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            let selectedMonth = self.months[picker.selectedRow(inComponent: 0)]
            let selectedYear = self.years[picker.selectedRow(inComponent: 1)]
            let components = DateComponents(year: selectedYear, month: selectedMonth)
            if let newDate = Calendar.current.date(from: components) {
                self.currentDate = newDate
                self.updateHeaderLabel()
                self.loadDaysInMonth(for: newDate)
            }
        }))
        
        self.presentVC(to: alert, animated: true)
    }
    
    
    private func isDateInRange(_ date: Date) -> Bool {
        guard let start = startDate, let end = endDate else { return false }
        return (start...end).contains(date)
    }
}

extension CustomDatePickerView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return daysInMonth.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DateCell", for: indexPath) as! DateCell
        
        let date = daysInMonth[indexPath.item]
        let isStart = Calendar.current.isDate(date, inSameDayAs: startDate ?? Date.distantFuture)
        let isEnd = Calendar.current.isDate(date, inSameDayAs: endDate ?? Date.distantFuture)
        let inRange = isDateInRange(date)
        
        cell.configure(with: date, isSelected: inRange, isStart: isStart, isEnd: isEnd)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDate = daysInMonth[indexPath.item]
        let calendar = Calendar.current
        
        if calendar.isDate(selectedDate, equalTo: Date.distantPast, toGranularity: .day) {
            return // Ignore empty cells
        }
        
        if startDate == nil || (startDate != nil && endDate != nil) {
            // Start a new selection range
            startDate = selectedDate
            endDate = nil
        } else if let start = startDate {
            // Second tap, set endDate and reorder if needed
            if selectedDate < start {
                endDate = start
                startDate = selectedDate
            } else {
                endDate = selectedDate
            }
        }
        
        collectionView.reloadData()
    }
    
}

extension CustomDatePickerView: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2 // month and year
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return component == 0 ? months.count : years.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if component == 0 {
            let formatter = DateFormatter()
            let monthName = formatter.monthSymbols[months[row] - 1]
            return monthName
        } else {
            return "\(years[row])"
        }
    }
    
}
