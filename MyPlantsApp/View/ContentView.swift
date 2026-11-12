//
//  ContentView.swift
//  MyPlantsApp
//
//  Created by Ghaida on 09/11/2026.
//

import SwiftUI

struct ContentView: View {
    
    @State private var showSheet = false
    @State private var showMyPlants = false
    @State private var didSavePlant = false
    
    var body: some View {
        if showMyPlants {
            MyPlantsHomeView()
        } else {
            VStack(spacing: 20) {
                
                
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
                    .frame(width: 200, height: 200)
                
                Text("Start your plant journey!")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                Text("Now all your plants will be in one place and we will help you take care of them :)🪴")
                    .font(.system(size: 18))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                
                
                Button("Set Plant Reminder") {
                    showSheet = true
                }
                
                .buttonStyle(.borderedProminent)
                .tint(
                    Color(
                        red: 40/255,
                        green: 127/255,
                        blue: 104/255
                    )
                )
                .controlSize(.large)
                
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
