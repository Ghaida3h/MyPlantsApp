//
//  SetReminderView.swift
//  MyPlantsApp
//
//  Created by Ghaida on 10/11/2026.
//

import SwiftUI

struct SetReminderView: View {
    @Binding var didSavePlant: Bool
    @Environment(\.dismiss) private var dismiss
    @Environment(PlantViewModel.self) private var viewModel
    @State private var plantName = ""
    @State private var selectedRoom = "Bedroom"
    @State private var selectedLight = "Full Sun"
    @State private var selectedWateringDays = "Every day"
    @State private var selectedWater = "20-50 ml"
    
    var editingIndex: Int? = nil
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20)
        {
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 50, height: 50)
                        .background {
                            Circle()
                                .fill(Color(red: 0.16, green: 0.16, blue: 0.17))
                                .glassEffect(.regular, in: .circle)
                        }
                }
                .buttonStyle(.plain)
                
                
                
                Spacer()
                
                Text("Set Reminder")
                    .font(.headline)
                Spacer()
                
                
                
                
                Button {
                    let newPlant = Plant(
                        name: plantName,
                        room: selectedRoom,
                        light: selectedLight,
                        wateringDays: selectedWateringDays,
                        waterAmount: selectedWater
                    )
                    if let editingIndex = editingIndex {
                        viewModel.updatePlant(at: editingIndex, with: newPlant)
                    } else {
                        viewModel.addPlant(plant: newPlant)
                        viewModel.requestNotificationPermission(for: newPlant)
                    }
                    

                    didSavePlant = true
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        }
                .buttonStyle(.glassProminent)
                .tint(Color(red: 40/255, green: 127/255, blue: 104/255))
                .buttonBorderShape(.circle)
            }
            HStack(spacing: 8) {
                Text("Plant Name")
                    .foregroundStyle(.white)

                TextField("Pothos", text: $plantName)
                    .foregroundStyle(.white)
                    .tint(.mint)
            }
            .padding()
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.bottom, 25)
            
            
            
            VStack(spacing: 0) {
                
                HStack{
                    Label("Room", systemImage: "location")
                    
                    
                    
                    
                    
                    Spacer()
                    
                    Picker("Room", selection: $selectedRoom) {
                        Text("Bedroom").tag("Bedroom")
                        Text("Living Room").tag("Living Room")
                        Text("Kitchen").tag("Kitchen")
                        Text("Balcony").tag("Balcony")
                        Text("Bathroom").tag("Bathroom")
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .tint(.gray)
                    
                    
                }
                .padding()
                
                Divider()
                    .overlay(Color.gray.opacity(0.5))
                    .padding(.horizontal, 16)
                
                
                HStack {
                    Label("Light", systemImage: "sun.max")
                    
                    Spacer()
                    
                    Picker("Light", selection: $selectedLight) {
                        Text("Full Sun").tag("Full Sun")
                        Text("Partial Sun").tag("Partial Sun")
                        Text("Low Light").tag("Low Light")
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .tint(.gray)
                }
                .padding()
                
                
            }
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            .padding(.bottom, 25)
            
            VStack(spacing: 0) {
                HStack {
                    Label("Watering Days", systemImage: "drop")

                    Spacer()

                    Picker("Watering Days", selection: $selectedWateringDays) {
                        Text("Every day").tag("Every day")
                        Text("Every 2 days").tag("Every 2 days")
                        Text("Every 3 days").tag("Every 3 days")
                        Text("Once a week").tag("Once a week")
                        Text("Every 10 days").tag("Every 10 days")
                        Text("Every 2 weeks").tag("Every 2 weeks")
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .tint(.gray)
                }
                .padding()
                
                
                Divider()
                    .overlay(Color.gray.opacity(0.5))
                    .padding(.horizontal, 16)

                HStack {
                    Label("Water", systemImage: "drop")

                    Spacer()

                    Picker("Water", selection: $selectedWater) {
                        Text("20-50 ml").tag("20-50 ml")
                        Text("50-100 ml").tag("50-100 ml")
                        Text("100-200 ml").tag("100-200 ml")
                        Text("200-300 ml").tag("200-300 ml")
                    }
                    .labelsHidden()
                    .pickerStyle(.menu)
                    .tint(.gray)
                }
                .padding()
            }
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 30))
            
            
            if let editingIndex = editingIndex {
               

                Button {
                    viewModel.deletePlant(at: editingIndex)
                    dismiss()
                } label: {
                    Text("Delete Reminder")
                        .font(.system(size: 16))
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 30))
                        .buttonStyle(.glass)
                        .buttonBorderShape(.roundedRectangle(radius: 20))
                        .padding(.top, 25)
                }
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(Color(red: 0.12, green: 0.12, blue: 0.13))
        .foregroundStyle(.white)
        .onAppear {
            loadPlantData()
        }
    }
    
    private func loadPlantData() {
        guard let editingIndex = editingIndex else { return }

        let plant = viewModel.plants[editingIndex]

        plantName = plant.name
        selectedRoom = plant.room
        selectedLight = plant.light
        selectedWateringDays = plant.wateringDays
        selectedWater = plant.waterAmount    }
}
    
    
    #Preview {
        SetReminderView(didSavePlant: .constant(false))
            .environment(PlantViewModel())
    }

