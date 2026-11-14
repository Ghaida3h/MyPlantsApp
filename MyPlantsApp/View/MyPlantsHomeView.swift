//
//  MyPlantsHomeView.swift
//  MyPlantsApp
//
//  Created by Ghaida on 11/11/2026.
//

import SwiftUI

struct MyPlantsHomeView: View {
    @Environment(PlantViewModel.self) private var viewModel
    @State private var showAddPlant = false
    @State private var editingPlantIndex: Int? = nil
    
    private var wateredCount: Int {
        viewModel.plants.filter { $0.isWatered }.count
    }
    
    private var wateringProgress: Double {
        guard !viewModel.plants.isEmpty else { return 0 }

        return Double(wateredCount) / Double(viewModel.plants.count)
    }
    
    
    private var allWatered: Bool {
        !viewModel.plants.isEmpty &&
        wateredCount == viewModel.plants.count
    }
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            
            VStack(alignment: .leading, spacing: 20) {
                Text("My Plants 🌱")
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Divider()
                    .overlay(Color.gray.opacity(0.3))
                
                if allWatered {
                    
                    Spacer()
                    
                    VStack(spacing: 20) {
                        Image("all done")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 200)
                        
                        Text("All Done! 🎉")
                            .font(.title)
                            .bold()
                            .foregroundStyle(.white)
                        
                        Text("All Reminders Completed")
                            .font(.subheadline)
                            .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    
                    Spacer()
                    
                } else {
                    
                    
                    Text(
                        wateredCount == 0
                        ? "Your plants are waiting for a sip 💦"
                        : "\(wateredCount) of your plants feel loved today ✨"
                    )
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                    
                    ProgressView(value: wateringProgress, total: 1.0)
                        .tint(.mint)
                        .padding(.horizontal, 10)
                        .animation(.easeInOut(duration: 0.4), value: wateringProgress)
                    
                    List {
                        ForEach(viewModel.plants.indices, id: \.self) { index in
                            let plant = viewModel.plants[index]
                            
                            HStack(spacing: 20) {
                                Button {
                                    viewModel.plants[index].isWatered.toggle()
                                } label: {
                                    Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                        .font(.system(size: 28))
                                        .foregroundStyle(
                                            plant.isWatered ? Color.mint : Color.gray
                                        )
                                }
                                .buttonStyle(.plain)
                                
                                VStack(alignment: .leading, spacing: 10) {
                                    Label("in \(plant.room)", systemImage: "location")
                                        .font(.system(size: 14))
                                        .foregroundStyle(.gray)
                                    
                                    Button {
                                        editingPlantIndex = index
                                    } label: {
                                        Text(plant.name)
                                            .font(.system(size: 30))
                                            .foregroundStyle(.white)
                                    }
                                    .buttonStyle(.plain)
                                    
                                    HStack(spacing: 10) {
                                        Label(plant.light, systemImage: "sun.max")
                                            .foregroundStyle(Color(red: 0.95, green: 0.87, blue: 0.65))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        
                                        
                                        Label(plant.waterAmount, systemImage: "drop")
                                            .foregroundStyle(Color(red: 0.68, green: 0.85, blue: 0.95))
                                            .padding(.horizontal, 10)
                                            .padding(.vertical, 5)
                                            .background(Color.gray.opacity(0.2))
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                    }
                                    .font(.system(size: 14))
                                    
                                }
                                
                                Spacer()
                            }
                            
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.deletePlant(at: index)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                .tint(.red)
                            }
                            
                            .listRowBackground(Color.black)
                            .listRowSeparator(.hidden)
                            .listRowInsets(
                                EdgeInsets(top: 12, leading: 0, bottom: 12, trailing: 0)
                            )
                            
                            
                            
                        } // End ForEach

                    } // End List
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)

                } // End else

                
                
            } // End VStack
            
    
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .topLeading
            )
            
            
            Button {
                showAddPlant = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 24, weight: .medium))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
            }
            .buttonStyle(.glassProminent)
            .tint(Color(red: 40/255, green: 127/255, blue: 104/255))
            .buttonBorderShape(.circle)
                  .padding(2)
            
        }
    
     
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .background(Color.black)
        .sheet(isPresented: $showAddPlant) {
            SetReminderView(didSavePlant: .constant(false))
                .presentationBackground(
                    Color(red: 0.12, green: 0.12, blue: 0.13)
                )
        }
        .sheet(isPresented: Binding(
            get: { editingPlantIndex != nil },
            set: { if !$0 { editingPlantIndex = nil } }
        )) {
            if let index = editingPlantIndex {
                SetReminderView(
                    didSavePlant: .constant(false),
                    editingIndex: index
                )
                .presentationBackground(
                    Color(red: 0.12, green: 0.12, blue: 0.13)
                )
            }
        }
        
    }
}
#Preview {
    MyPlantsHomeView()
        .environment(PlantViewModel())
}
