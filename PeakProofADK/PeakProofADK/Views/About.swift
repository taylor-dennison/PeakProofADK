//
//  About.swift
//  NPF-4
//
//  Created by Taylor Dennison on 11/23/22.
//

import SwiftUI

struct About: View {
    
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init() {
    
    }
    
    var body: some View {
        ZStack {
            Image("marcy")
                .resizable()
                .scaledToFit()
                .scaleEffect(3.5)
        
            VStack {
                Spacer()
                RoundedRectangle(cornerRadius: 10)
                    .padding(20)
                    .opacity(0.85)
                    .overlay(
                        Text("PeakProofADK\n\nBy\n\nTaylor Dennison")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .bold()
                            .multilineTextAlignment(.center)
                            
                    )//overlay
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .padding(20)
                    .opacity(0.85)
                    .overlay(
                        Text("Mobile Application Development Final Project")
                            .padding(20)
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .bold()
                            .multilineTextAlignment(.center)
                            .lineSpacing(20)
                            
                        
                            
                    )//overlay
                
                Spacer()
                
                RoundedRectangle(cornerRadius: 10)
                    .padding(20)
                    .opacity(0.85)
                    .overlay(
                        Text("All High Peak information sourced from www.adirondack.net and www.adk.org")
                            .font(.system(.title, design: .rounded))
                            .foregroundColor(colorScheme == .dark ? .black : .white)
                            .bold()
                            .multilineTextAlignment(.center)
                            .lineSpacing(10)
                            
                        
                            
                    )//overlay
                }
            Spacer()
                
            }
            
            
        
    }
}

struct About_Previews: PreviewProvider {
    static var previews: some View {
        About()
    }
}
