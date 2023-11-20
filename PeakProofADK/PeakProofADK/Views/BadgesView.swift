//
//  BadgesView.swift
//  PeakProofADK
//
//  Created by Taylor Dennison on 12/3/22.
//

import SwiftUI
import CodeScanner

enum FilterBadges: Hashable {
    case all
    case earned
}

struct BadgesView: View {
    
    @EnvironmentObject var peaks: Peaks
    @State private var filter: FilterBadges = FilterBadges.all
    @State private var scrollViewID = UUID()
    @State private var showQRCodeScanner = false
    @State private var showAlert = false
    @State private var scannedCode: String?
    @State private var scrollViewProxy: ScrollViewProxy?
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: Badge.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Badge.name, ascending: false)])
    var earnedBadgesData: FetchedResults<Badge>
    
    var allEarnedBadgeNames: [String] {
        var earnedBadges: [String] = []
        for badge in earnedBadgesData {
            if (badge.earned) {
                earnedBadges.append(badge.name)
            }
        }
        return earnedBadges
    }
    
    var allPeakNames: [String] {
        var peakNames: [String] = []
        for peak in peaks.highPeaks {
            peakNames.append(peak.peakName)
        }
        return peakNames
    }
    
    private func markBadgeAsEarned(name: String) {
        
        let badge = Badge(context: context)
        badge.name = name
        badge.earned = true
        
        do {
            try context.save()
        } catch {
            print(error)
        }
    }
    
    //determine the ID of the first element to allow auto scroll to top when FilterBadges change.
    var firstIndexID: UUID {
        return peaks.highPeaks.first!.id
    }
    
    func determineListId() -> UUID {
        
        guard scannedCode != nil else {
            return firstIndexID
        }
        
        let peak = peaks.highPeaks.firstIndex { peak in
            return peak.peakName == scannedCode
        }
        
        return peaks.highPeaks[peak!].id
    }

    var body: some View {
        
        NavigationView {
            
            ScrollViewReader { proxy in
                
                List(peaks.highPeaks) { peak in
                    
                    HStack {
                        Text("\(peak.peakName)")
                            .font(.system(.title, design: .rounded))
                            .bold()
                        
                        Spacer()
                        
                        Image("\(peak.getPatch())")
                            .resizable()
                            .frame(width:100, height: 100)
                            .opacity(allEarnedBadgeNames.contains(peak.peakName) ? 1.0 : 0.4)
                    }
                }
                .listStyle(PlainListStyle())
                .navigationBarTitle("Badges", displayMode: .large)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        Picker("Sort By", selection: $filter) {
                            Text("All").tag(FilterBadges.all)
                            Text("Earned").tag(FilterBadges.earned)
                            
                        }
                        .pickerStyle(SegmentedPickerStyle())
                        .padding(.top)
                    }
                    
                    ToolbarItem(placement: .bottomBar) {
                        Button {
                            showQRCodeScanner = true
                        } label: {
                            Text("Earn Badge")
                                .font(.system(.title2, design: .rounded))
                                .bold()
                        }
                        
                    }
                }
                .onChange(of: filter) { newValue in
                    
                    proxy.scrollTo(firstIndexID)
                    
                    switch(filter) {
                    case .all:
                        peaks.highPeaks.sort(by: {$0.peakName < $1.peakName})
                    case .earned:
                        peaks.highPeaks.sort(by: {
                            print($1)
                            return allEarnedBadgeNames.contains($0.peakName)
                        })
                    }
                    
                    
                }
                .onAppear() {
                    scrollViewProxy = proxy
                }
                
            }
            .sheet(isPresented: $showQRCodeScanner) {
                
                CodeScannerView(codeTypes: [.qr]) { response in
                    switch response {
                    case .success(let result):
                        if (allPeakNames.contains(result.string)) {
                            scannedCode = result.string
                            markBadgeAsEarned(name: result.string)
                            showAlert = true
                        } else {
                            showAlert = true
                        }
                        
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        showQRCodeScanner = false
                    }
                    
                }
                .alert(isPresented: $showAlert) {
                    if scannedCode != nil {
                        return Alert(title: Text("Congratulations!"), message: Text("You've Earned a Badge!"), dismissButton: .default(Text("See Badge"), action: {
                                showAlert = false
                                showQRCodeScanner = false
                                                    
                        }))
                    } else {
                        return Alert(title: Text("Uh oh!"), message: Text("This doesnt look like a legit PeakProof peak!"), dismissButton: .default(Text("Oh well"), action: {
                                showAlert = false
                                showQRCodeScanner = false
                                    
                            }))
                    }
                }
                
                .onDisappear() {
                    if scannedCode != nil {
                        withAnimation(Animation.easeIn(duration: 5)) {
                            scrollViewProxy!.scrollTo(determineListId(), anchor: .center)
                        }
                    }
                    scannedCode = nil
                }
            }
            
            
            
           
        }
        
        
    }
}


struct BadgesView_Previews: PreviewProvider {
    static var previews: some View {
        BadgesView()
    }
}
