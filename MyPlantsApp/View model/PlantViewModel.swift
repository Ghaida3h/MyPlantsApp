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
    
    init() {
        loadPlants()
    }
    
    func savePlants() {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: "savedPlants")
        }
    }
    
    func loadPlants() {
        guard let data = UserDefaults.standard.data(forKey: "savedPlants"),
              let savedPlants = try? JSONDecoder().decode([Plant].self, from: data)
        else {
            return
        }

        plants = savedPlants
        refreshWateringStatus()
    }
    
    
    func addPlant(plant: Plant) {
        plants.append(plant)
        savePlants()
    }
    
    func deletePlant(at index: Int) {
        guard plants.indices.contains(index) else { return }
        
        let plant = plants[index]
        cancelWateringNotification(for: plant)
        plants.remove(at: index)
        savePlants()
    }
    
    
    func updatePlant(at index: Int, with updatedPlant: Plant) {
        let oldPlant = plants[index]

        cancelWateringNotification(for: oldPlant)

        var editedPlant = updatedPlant
        editedPlant.id = oldPlant.id
        editedPlant.isWatered = oldPlant.isWatered
        editedPlant.lastWateredDate = oldPlant.lastWateredDate

        plants[index] = editedPlant
        savePlants()

        requestNotificationPermission(for: editedPlant)
    }
    
    
    func toggleWatered(for plantID: UUID) {
        guard let index = plants.firstIndex(where: { $0.id == plantID }) else {
            return
        }

        plants[index].isWatered.toggle()

        if plants[index].isWatered {
            plants[index].lastWateredDate = Date()
        } else {
            plants[index].lastWateredDate = nil
        }

        savePlants()

        let updatedPlant = plants[index]
        cancelWateringNotification(for: updatedPlant)
        scheduleWateringNotification(for: updatedPlant)
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
    
    func refreshWateringStatus() {
        var hasChanges = false

        for index in plants.indices {
            let plant = plants[index]

            guard plant.isWatered,
                  let lastDate = plant.lastWateredDate else {
                continue
            }

            let days = wateringInterval(for: plant.wateringDays)

            if let nextDate = Calendar.current.date(
                byAdding: .day,
                value: days,
                to: lastDate
            ), Date() >= nextDate {
                plants[index].isWatered = false
                hasChanges = true
            }
        }

        if hasChanges {
            savePlants()
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
        let id = plant.id.uuidString

        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(
                withIdentifiers: [id]
            )

        UNUserNotificationCenter.current()
            .removeDeliveredNotifications(
                withIdentifiers: [id]
            )
    }
    
    }

