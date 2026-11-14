//
//  PlantViewModel.swift
//  MyPlantsApp
//
//  Created by Ghaida on 10/11/2026.
//

import Foundation
import UserNotifications
@Observable
class PlantViewModel{
    var plants:[Plant]=[]
    
    
    func addPlant(plant:Plant){
        plants.append(plant)
    }
    
    func deletePlant(at index: Int) {
        let plant = plants[index]
        cancelWateringNotification(for: plant)
        plants.remove(at: index)
    }
    
    func updatePlant(at index: Int, with updatedPlant: Plant) {
        let oldPlant = plants[index]

        cancelWateringNotification(for: oldPlant)

        var editedPlant = updatedPlant
        editedPlant.id = oldPlant.id
        editedPlant.isWatered = oldPlant.isWatered

        plants[index] = editedPlant

        requestNotificationPermission(for: editedPlant)
    }
    
    func requestNotificationPermission(for plant: Plant) {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in

                if let error = error {
                    print("Notification error: \(error.localizedDescription)")
                    return
                }

                if granted {
                    self.scheduleWateringNotification(for: plant)
                } else {
                    print("Notification permission denied")
                }
            }
    }
    func sendTestNotification() {
        let content = UNMutableNotificationContent()

        content.title = "Time to water your plant! 🌱"
        content.body = "Your plant is waiting for a sip 💧"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: 10,
            repeats: false
        )

        let request = UNNotificationRequest(
            identifier: "testNotification",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request)
    }
    func wateringInterval(for days: String) -> Int {
        switch days {
        case "Every day":
            return 1
        case "Every 2 days":
            return 2
        case "Every 3 days":
            return 3
        case "Once a week":
            return 7
        case "Every 10 days":
            return 10
        case "Every 2 weeks":
            return 14
        default:
            return 1
        }
    }
    func scheduleWateringNotification(for plant: Plant) {
        let days = wateringInterval(for: plant.wateringDays)

        let content = UNMutableNotificationContent()
        content.title = "Time to water \(plant.name)! 🌱"
        content.body = "Your \(plant.name) needs some water 💧"
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(
            timeInterval: TimeInterval(days * 24 * 60 * 60),
            repeats: true
        )

        let request = UNNotificationRequest(
            identifier: plant.id.uuidString,
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Scheduling error: \(error.localizedDescription)")
            } else {
                print("Notification scheduled for \(plant.name)")
            }
        }
    }
    func cancelWateringNotification(for plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [plant.id.uuidString]
            )
    }
    
    }

