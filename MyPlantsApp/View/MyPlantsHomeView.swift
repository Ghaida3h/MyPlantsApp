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
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            
            
            VStack(alignment: .leading, spacing: 20) {
                Text("My Plants 🌱")
                    .font(.system(size: 36))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Divider()
                    .overlay(Color.gray.opacity(0.3))
                
                Text("Your plants are waiting for a sip 💦")
                    .font(.system(size: 18))
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 30)
                
                ProgressView(value: 0.0, total: 1.0)
                    .tint(.green)
                    .padding(.horizontal, 10)
                
                ForEach(viewModel.plants.indices, id: \.self) { index in
                    let plant = viewModel.plants[index]
                    
                    HStack(spacing: 20) {
                        Image(systemName: "circle")
                            .font(.system(size: 28))
                            .foregroundStyle(.gray)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            Label("in \(plant.room)", systemImage: "location")
                                .font(.system(size: 14))
                                .foregroundStyle(.gray)
                            
                            Text(plant.name)
                                .font(.system(size: 30))
                                .foregroundStyle(.white)
                            
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
                    
                    Divider()
                        .overlay(Color.gray.opacity(0.3))
                }
            }
            
            
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
                          .frame(width: 60, height: 60)
                          .background(Color(red: 40/255, green: 127/255, blue: 104/255))
                          .clipShape(Circle())
                      
                  }
                  .padding(20)
            
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
    }
}
#Preview {
    MyPlantsHomeView()
        .environment(PlantViewModel())
}
