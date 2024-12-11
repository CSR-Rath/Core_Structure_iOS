//
//  ReservationController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/12/24.
//

import UIKit

class ReservationViewController: UIViewController, UITextFieldDelegate {
    
    var geustID: Int = 0
    var roomID: Int = 0
    var room: Room?

    // MARK: - Properties
    private let guestNameTextField = UITextField()
    private let roomNumberTextField = UITextField()
    private let checkInDatePicker = UIDatePicker()
    private let checkOutDatePicker = UIDatePicker()
    private let labelGeust = UILabel()
    private let labelRoomName = UILabel()
    private let labelPrice = UILabel()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        leftBarButton()
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Set the minimum date for checkInDatePicker
        checkInDatePicker.minimumDate = Date()
        checkOutDatePicker.minimumDate = Date()
        
        // Add target actions for date pickers
        checkInDatePicker.addTarget(self, action: #selector(checkInDateChanged), for: .valueChanged)
        checkOutDatePicker.addTarget(self, action: #selector(checkOutDateChanged), for: .valueChanged)
    }

    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .white
        title = "Create Reservation"
        labelGeust.text = "Guest Name"
        labelRoomName.text = "Room Name"

        let stackView = UIStackView(arrangedSubviews: [
            labelGeust,
            createTextField("Guest Name", textField: guestNameTextField, tag: 0),
            labelRoomName,
            createTextField("Room Number", textField: roomNumberTextField, tag: 1),
            labelPrice,
            createDatePicker("Check-in Date", datePicker: checkInDatePicker),
            createDatePicker("Check-out Date", datePicker: checkOutDatePicker),
        ])
        
        labelPrice.text = "Price per night: $0.00"

        stackView.axis = .vertical
        stackView.spacing = 16
        stackView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stackView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20)
        ])
        
        let saveButton = MainButton()
        saveButton.setTitle("Save Reservation", for: .normal)
        saveButton.addTarget(self, action: #selector(saveReservation), for: .touchUpInside)
        saveButton.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(saveButton)
        
        NSLayoutConstraint.activate([
            saveButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 20),
            saveButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    private func createTextField(_ placeholder: String, textField: UITextField, tag: Int) -> UIView {
        textField.placeholder = placeholder
        textField.borderStyle = .roundedRect
        textField.keyboardType = .default
        textField.tintColor = .clear
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        textField.delegate = self
        textField.tag = tag
        
        // Add tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(textFieldTapped(_:)))
        textField.addGestureRecognizer(tapGesture)
        
        return textField
    }

    @objc private func checkInDateChanged() {
        let selectedDate = checkInDatePicker.date
        let currentDate = Date()

        // Update minimum date for checkOutDatePicker
        checkOutDatePicker.minimumDate = selectedDate
        
        // Show an alert if the selected date is in the past
        if selectedDate < currentDate {
            showAlert("Check-in date cannot be in the past.")
        }
    }

    @objc private func checkOutDateChanged() {
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date

        // Show an alert if the check-out date is before or equal to check-in date
        if checkOutDate <= checkInDate {
            showAlert("Check-out date must be later than check-in date.")
        }
    }

    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Invalid Date", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    private func createDatePicker(_ text: String, datePicker: UIDatePicker) -> UIView {
        let label = UILabel()
        label.text = text
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = .mainBlueColor
        let container = UIView()
        container.addSubview(label)
        container.addSubview(datePicker)
        
        datePicker.datePickerMode = .date
        
        // Layout for label and date picker
        label.translatesAutoresizingMaskIntoConstraints = false
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            
            datePicker.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 8),
            datePicker.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            datePicker.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            datePicker.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        return container
    }

    @objc private func textFieldTapped(_ sender: UITapGestureRecognizer) {
        guard let textField = sender.view as? UITextField else { return }
        
        if textField.tag == 0 { // Guest Name
            let vc =  GeustsListController()//GuestsListController() // Assuming this is the correct controller
            vc.didSelectRow = { guest in
                self.guestNameTextField.text = guest.lastName
                self.geustID = guest.id
                vc.dismiss(animated: true)
            }
            self.present(vc, animated: true)
            
        } else if textField.tag == 1 { // Room Number
            let vc = RoomListViewController()
            vc.isFromReservation = true
            vc.didSelectedCell = { room in
                self.roomID = room.id
                self.room = room
                self.roomNumberTextField.text = room.roomName
                self.labelPrice.text = "Price per night: \(room.pricePerNight.twoDigit(sign: "$"))"
                vc.dismiss(animated: true)
            }
            self.present(vc, animated: true)
        }
    }
    
    @objc private func saveReservation() {
        guard geustID != 0 else {
            showAlert("Please select a guest.")
            return
        }

        guard roomID != 0 else {
            showAlert("Please select a room.")
            return
        }

        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date

        // Validate check-in and check-out dates
        if checkOutDate <= checkInDate {
            showAlert("Check-out date must be later than check-in date.")
            return
        }

        Loading.shared.showLoading()
        
        // Calculate the number of nights
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: checkInDate, to: checkOutDate)
        let numberOfNights = (components.day ?? 0) + 1

        // Create a DateFormatter instance
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        let formattedCheckInDate = dateFormatter.string(from: checkInDate)
        let formattedCheckOutDate = dateFormatter.string(from: checkOutDate)

        // Calculate total amount based on room price per night
        let roomPricePerNight: Double = room?.pricePerNight ?? 0 // Example price per night; replace with your logic
        let totalAmount = Double(numberOfNights) * roomPricePerNight
        
        print("numberOfNights = " ,numberOfNights)
        print("roomPricePerNight = " ,roomPricePerNight)
        print("totalAmount = " ,totalAmount)
        print("room = ", room)

        let reservation = Reservation(reservationId: 0,
                                      guest: geustID,
                                      room: roomID,
                                      checkInDate: formattedCheckInDate,
                                      checkOutDate: formattedCheckOutDate,
                                      totalAmount: totalAmount,
                                      status: "pending")

        // Call the API to save the reservation
        ReservationViewModel.shared.post_put_Reservation(param: reservation,
                                                         method: .POST) { [self] response in
            Loading.shared.hideLoading()
            // Handle response
            if response.response.status > 199 && response.response.status < 300 {
                
                guestNameTextField.text = ""
                roomNumberTextField.text = ""
                labelPrice.text = "Price per night: $0.00"
                checkInDatePicker.date = Date()
                checkOutDatePicker.date = Date()
                 
                print("Reservation saved successfully.")
                // Optionally, dismiss the view or show a success message
            } else {
                print("Failed to save reservation: \(response.response.message)")
                self.showAlert("Failed to save reservation. Please try again.")
            }
        }
    }
}
