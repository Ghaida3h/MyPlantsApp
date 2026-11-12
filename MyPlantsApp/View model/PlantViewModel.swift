//
//  PlantViewModel.swift
//  MyPlantsApp
//
//  Created by Ghaida on 10/11/2026.
//

import Foundation
@Observable
class PlantViewModel{
    var plants:[Plant]=[]
    
    
    func addPlant(plant:Plant){
        plants.append(plant)
    }
    
    }

