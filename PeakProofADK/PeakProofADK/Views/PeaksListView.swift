//
//  PeaksListView.swift
//
//  Created by Taylor Dennison on 11/23/22.
//

import SwiftUI
import MapKit


enum FilterBy: Hashable {
    case alphabetical
    case reverseAlphabetical
    case difficulty
}

struct PeaksListView: View {
    
    @EnvironmentObject var peaks: Peaks
    @Binding var selectedTab: Tabs
    @State var filter = FilterBy.alphabetical
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    var body: some View {
   
        NavigationStack {
            VStack {
                if peaks.highPeaks.isEmpty {
                    //could be any view, stack, etc.
                    Text("Oops, it looks like there's no data!")
                } else {
                
                    List(peaks.highPeaks) { peak in
                        NavigationLink(destination: PeakDetailView(peak: peak, selectedTab: $selectedTab)) {
                            PeakRow(peak: peak)
                        }//NavLink
                    }//List
                    .listStyle(PlainListStyle())
                    .toolbar {
                        ToolbarItem(placement: .principal) {
                            Picker("Sort By", selection: $filter) {
                                Text("A-Z").tag(FilterBy.alphabetical)
                                Text("Z-A").tag(FilterBy.reverseAlphabetical)
                                Text("Difficulty").tag(FilterBy.difficulty)
                            }
                            .pickerStyle(SegmentedPickerStyle())
                            .padding(.top)
                        }
                    }
                    .onChange(of: filter) { newValue in
                        switch(filter) {
                        case .alphabetical:
                            peaks.highPeaks.sort(by: {$0.peakName < $1.peakName})
                        case .reverseAlphabetical:
                            peaks.highPeaks.sort(by: {$0.peakName > $1.peakName})
                        case .difficulty:
                            peaks.highPeaks.sort(by: {$0.getDifficulty() < $1.getDifficulty()})
                        }
                    }
                }//else
            }//VStack
            .navigationBarTitle(Text("Peaks"), displayMode: .automatic)
            
        }//Navigation Stack
        .accentColor(colorScheme == .dark ? .white : .black)
    }
    
}

struct PeakRow: View {
    
    var peak: Peak
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(peak.peakName)")
                .font(.title)
                .fontWeight(.bold)
                
            Text("Elevation: \(peak.getElevation())")
                .font(.title2)
            
            Text("Difficulty: \(peak.getDifficulty())/7")
                .font(.title2)
        }
    }
    
  
}

struct PeaksListView_Previews: PreviewProvider {
    static var previews: some View {
        PeaksListView(selectedTab: .constant(Tabs.list))
    }
}
