//
//  ContentView.swift
//  MyPlantsApp
//
//  Created by Ghaida on 09/11/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet = false
    @AppStorage("hasStartedJourney") private var showMyPlants = false
    @State private var didSavePlant = false
    
    var body: some View {
        if showMyPlants {
            MyPlantsHomeView()
        } else {
            VStack(spacing: 25) {
                
                
                //title
                VStack(alignment: .leading, spacing: 20) {
                    Text("My Plants 🌱")
                        .font(.system(size: 36))
                        .fontWeight(.bold)
                        .foregroundStyle(.white)
                    
                    Divider()
                        .overlay(Color.gray)
                }
                
                
                Spacer()
                
                Image("plant")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 230, height: 230)
                    .padding(.bottom, 15)
                    
                
                Text("Start your plant journey!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                    .padding(.bottom, 5)
                
                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 70)
                
                
                Button {
                    showSheet = true
                } label: {
                    Text("Set Plant Reminder")
                        .font(.system(size: 17, weight: .medium))
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .buttonStyle(.glassProminent)
                .tint(Color(red: 40/255, green: 127/255, blue: 104/255))
               
                
                Spacer()
            }
            .padding()
            
            
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black)
            
            .sheet(isPresented: $showSheet) {
                SetReminderView(didSavePlant: $didSavePlant)
                    .presentationBackground(Color(red: 0.12, green: 0.12, blue: 0.13))
                
            }
            .onChange(of: didSavePlant) { _, saved in
                if saved {
                    showMyPlants = true
                }
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(PlantViewModel())
}
