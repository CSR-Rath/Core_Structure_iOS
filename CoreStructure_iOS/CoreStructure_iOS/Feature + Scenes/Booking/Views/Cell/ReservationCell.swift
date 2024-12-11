//
//  ReservationCell.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/12/24.
//

import UIKit

import UIKit

class ReservationCell: UITableViewCell {
    
    // MARK: - UI Elements
    private let guestNameLabel = UILabel()
    private let roomNumberLabel = UILabel()
    private let checkInLabel = UILabel()
    private let checkOutLabel = UILabel()
    private let totalAmountLabel = UILabel()
    private let statusLabel = UILabel()
    
    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        // Configure labels
        guestNameLabel.font = UIFont.boldSystemFont(ofSize: 16)
        roomNumberLabel.font = UIFont.systemFont(ofSize: 14)
        checkInLabel.font = UIFont.systemFont(ofSize: 14)
        checkOutLabel.font = UIFont.systemFont(ofSize: 14)
        totalAmountLabel.font = UIFont.systemFont(ofSize: 14)
        statusLabel.font = UIFont.systemFont(ofSize: 14)
        
        // Stack view for layout
        let stackView = UIStackView(arrangedSubviews: [
            guestNameLabel,
            roomNumberLabel,
            checkInLabel,
            checkOutLabel,
            totalAmountLabel,
            statusLabel
        ])
        
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(stackView)
        
        // Layout constraints
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    // MARK: - Configure Cell
    func configure(with reservation: Reservation) {
        guestNameLabel.text = "Geust ID: \(reservation.guest)"
        roomNumberLabel.text = "Room ID: \(reservation.room)"
        checkInLabel.text = "Check-in: \(reservation.checkInDate)"
        checkOutLabel.text = "Check-out: \(reservation.checkOutDate)"
        totalAmountLabel.text = "Total: \(reservation.totalAmount)"
//        statusLabel.text = "Status: \(reservation.status)"
    }
    
    // MARK: - Date Formatting
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter.string(from: date)
    }
}
