//
//  RoomListViewController.swift
//  CoreStructure_iOS
//
//  Created by Rath! on 4/12/24.
//

import UIKit

class RoomListViewController: UITableViewController {
    
    var isFromReservation: Bool = false
    
    var didSelectedCell: ((Room)->())?
    
    // Sample data
    var rooms: [Room] = []{
        didSet{
            tableView.reloadData()
            Loading.shared.hideLoading()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Room List"
        leftBarButton()
        tableView.register(RoomTableViewCell.self, forCellReuseIdentifier: "RoomCell")
        
        RoomViewModel.shared.getRoomList { response in
            DispatchQueue.main.async {
                self.rooms = response.results
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        if rooms.count > 0{
            tableView.restore()
        }else{
            tableView.setEmptyView()
        }
        
        return rooms.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RoomCell", for: indexPath) as! RoomTableViewCell
        let room = rooms[indexPath.row]
        
        if "available" == room.isAvailable{
            cell.backgroundColor =  .white
        }else{
            cell.backgroundColor = .red.withAlphaComponent(0.1)
        }
        
        cell.roomType.text = room.roomType
        cell.roomNameLabel.text = "Name: \(room.roomName) \t\t\t ID: \(room.id)"
        cell.roomAvailabilityLabel.text = "Price: \(room.pricePerNight.twoDigit(sign: "$"))"
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isFromReservation == true {
            let selectedRoom = rooms[indexPath.row]
            if selectedRoom.isAvailable == "available"{
                didSelectedCell?(selectedRoom)
            }else{
                showAlert("The room is not available.")
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    private func showAlert(_ message: String) {
        let alert = UIAlertController(title: "Message!", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}


