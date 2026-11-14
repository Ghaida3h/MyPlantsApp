//
//  Plant.swift
//  MyPlantsApp
//
//  Created by Ghaida on 10/11/2026.
//

import Foundation

struct Plant {
    var id: UUID = UUID()
    var name: String
    var room: String
    var light: String
    var wateringDays: String
    var waterAmount: String
    var isWatered: Bool = false
}
