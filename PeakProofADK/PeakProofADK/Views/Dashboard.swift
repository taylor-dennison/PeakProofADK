//
//  Dashboard.swift
//  PeakProofADK
//
//  Created by Taylor Dennison on 12/7/22.
//

import SwiftUI
import Foundation

struct Dashboard: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    @State private var progress: Float = 0.0
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Badge.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Badge.name, ascending: false)])
    var earnedBadgesData: FetchedResults<Badge>
    
    var body: some View {
        
        ZStack {
            VStack(alignment: .center) {
                
                VStack {
                    Text("Welcome to Peak Proof ADK!")
                        .font(.system(size: 36, design: .rounded))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.top, 36)
                    Text("Scan the QR code at the top of each peak to earn badges")
                        .font(.system(size: 24, design: .rounded))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding(.vertical, 8)
                        .padding(.horizontal)
                }
                
                
                Spacer()
                Text("Current Progress")
                    .padding()
                
                Gauge(value: progress) {
                    
                }
                currentValueLabel : {
                 
                }
                .gaugeStyle(.accessoryCircularCapacity)
                .tint(colorScheme == .dark ? .green : Color(.systemBlue))
                .scaleEffect(5)
                .padding(.bottom, 150)
                
                VStack() {
                    Text("Use the Map View to get directions to your next challenge")
                        .font(.system(size: 20))
                        .bold()
                        .multilineTextAlignment(.center)
                        .padding()
                    
                    Text("Get out there and earn all 46 Badges!")
                        .font(.system(size: 20))
                        .bold()
                    
                }
                
                Spacer()
            }
            .onAppear() {
                var earned: [String] = []
                for badge in earnedBadgesData {
                    if badge.earned {
                        earned.append(badge.name)
                    }
                }
                
                progress = Float(earned.count) / 46
            }
            
            Text(String(format: "%.1f", progress * 100) + "%")
               .font(.system(size: 72))
               .padding(.top, 24)
        }
        
    }
        
        
}

struct Dashboard_Previews: PreviewProvider {
    static var previews: some View {
        Dashboard()
    }
}
