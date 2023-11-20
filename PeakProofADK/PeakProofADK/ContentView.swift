//
//  ContentView.swift
//  NPF-4
//
//  Created by Taylor Dennison on 11/23/22.
//

import SwiftUI

enum Tabs: Hashable {
    case map
    case list
    case dashboard
    case favorites
    case about
}


struct ContentView: View {
    
    @EnvironmentObject private var peaks: Peaks
    @State private var selectedTab = Tabs.dashboard
    @State private var navBarAppearnace: UINavigationBarAppearance = UINavigationBarAppearance()
    @State private var reload = false
    @Environment(\.scenePhase) var scenePhase
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Badge.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Badge.name, ascending: false)])
    var earnedBadgesData: FetchedResults<Badge>
    
    
    func appearanceInit() {
        navBarAppearnace.largeTitleTextAttributes = [.foregroundColor: colorScheme == .dark ? UIColor.green : UIColor.systemBlue, .font: UIFont(name: "ArialRoundedMTBold", size: 35)!] //force unwrap because UIFont returns an optional incase font doesnt exist
        
        //change back button image
        navBarAppearnace.setBackIndicatorImage(UIImage(systemName: "arrow.left"), transitionMaskImage: UIImage(systemName: "arrow.left"))
        
        //change back button color
        UINavigationBar.appearance().tintColor = .black //doesnt work for now.
        
        //set appearances for different styles
        UINavigationBar.appearance().standardAppearance = navBarAppearnace
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearnace
        UINavigationBar.appearance().compactAppearance = navBarAppearnace
        
        UITabBar.appearance().backgroundColor = .systemGray2
        
        navBarAppearnace.titleTextAttributes = [.foregroundColor: colorScheme == .dark ? UIColor.white : UIColor.black, .font: UIFont(name: "ArialRoundedMTBold", size: 20)!] //force unwrap because UIFont returns an optional incase font doesnt exist
        
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(colorScheme == .dark ? .green : .blue)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: colorScheme == .dark ? UIColor.black : UIColor.white], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: colorScheme == .dark ? UIColor.black : UIColor.systemBlue], for: .normal)
        UISegmentedControl.appearance().backgroundColor = colorScheme == .dark ?  UIColor(Color(.systemGray2)) : UIColor(Color(red: 1.0, green: 1.0, blue: 1.0))
    }

    
    var body: some View {
  
        TabView(selection: $selectedTab) {
            MyMapTab()
                .tabItem {
                    Image(systemName: "map")
                    Text("Peak Map")
                }
                .tag(Tabs.map)
            PeaksListView(selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "list.dash")
                    Text("Peak List")
                }
                .tag(Tabs.list)
            Dashboard()
                .tabItem {
                    Image(systemName: "figure.hiking")
                    Text("Dashboard")
                }
                .tag(Tabs.dashboard)
            BadgesView()
                .tabItem {
                    Image(systemName: "medal")
                    Text("Badges")
                }
                .tag(Tabs.favorites)
            About()
                .tabItem {
                    Image(systemName: "book")
                    Text("About")
                }
                .tag(Tabs.about)
        }
        .accentColor(colorScheme == .dark ? .green : .blue)
        .onAppear() {
            //initialize core data if first load.
            if earnedBadgesData.isEmpty {

                for peak in peaks.highPeaks {
                    let badge = Badge(context: context)
                    badge.name = peak.peakName
                    badge.earned = false
                    do {
                        try context.save()
                    } catch {
                        print(error)
                    }
                }
            }
            
            appearanceInit()
        }
        .id(self.colorScheme) //this will force contentview to redraw when colorscheme changes are detected

    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(Peaks())
    }
}
