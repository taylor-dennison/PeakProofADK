//
//  PeakDetailView.swift
//
//
//  Created by Taylor Dennison on 11/23/22.
//


import SwiftUI
import MapKit

enum logUpdateOption: Hashable {
    case comments
    case weatherConditions
    case date
    case season
}

struct PeakDetailView: View {
    
    var peak: Peak
    @EnvironmentObject  var peaks: Peaks
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var selectedTab: Tabs
    @State private var showLogSheet = false
    @State private var dateField: String = ""
    @State private var weatherConditionsField: String = ""
    @State private var commentsField: String = ""
    @State private var seasonField: String = ""
    @FocusState private var commentFocused: Bool
    
    @Environment(\.managedObjectContext) var context
    @FetchRequest(entity: LogEntry.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \LogEntry.peakName, ascending: false)])
    var logEntryData: FetchedResults<LogEntry>
    
    private var peakLogEntry: LogEntry? {
        
        for log in logEntryData {
            if peak.peakName == log.peakName {
                return log
            }
        }
        
        return nil
    }
    
    func handleUpdateLogEntry(logEntry: LogEntry, option: logUpdateOption) {

        switch(option) {
        case .date:
            context.performAndWait {
                logEntry.date = dateField
                try? context.save()
                print("updated date")
            }
        case .weatherConditions:
            context.performAndWait {
                logEntry.weatherConditions = weatherConditionsField
                try? context.save()
            }
        case .comments:
            context.performAndWait {
                logEntry.comments = commentsField
                try? context.save()
            }
        case .season:
            context.performAndWait {
                logEntry.season = seasonField
                try? context.save()
            }
        }
       
    }
    
    func handleCreateNewLogEntry(option: logUpdateOption) {
        let logEntry = LogEntry(context: self.context)
        logEntry.peakName = peak.peakName
        logEntry.date = ""
        logEntry.season = ""
        logEntry.comments = ""
        logEntry.weatherConditions = ""
        
        switch(option) {
        case .date:
            context.performAndWait {
                logEntry.date = dateField
                try? context.save()
                print("saved new log with date")
            }
        case .weatherConditions:
            context.performAndWait {
                logEntry.weatherConditions = weatherConditionsField
                try? context.save()
            }
        case .comments:
            context.performAndWait {
                logEntry.comments = commentsField
                try? context.save()
            }
        case .season:
            context.performAndWait {
                logEntry.season = seasonField
                try? context.save()
            }
        }
       
    }
    
    var body: some View {
        List {
            Section() {
                VStack {
                    Image("\(peak.getImage())")
                        .resizable()
                        .frame(width: 325, height: 325)
                        .cornerRadius(8)
                    Divider()
                    Section() {
                        Text("Show on Map")
                        .font(.system(.title2))
                        .bold()
                        .foregroundColor(colorScheme == .dark ? .green : .blue)
                        .onTapGesture {
                            peaks.selectedHighPeak = peak
                            selectedTab = Tabs.map
                            
                        }
                        
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                    Group {
                        Text("Peak Elevation: \(peak.getElevation())")
                        Divider()
                        Text("Ascent of Climb: \(peak.getAscentOfClimb())")
                        Divider()
                        Text("Peak Difficulty: \(peak.getDifficulty()) / 7")
                        Divider()
                    }
                    Group {
                        Text("Average Duration: \(peak.getAverageDuration())")
                        Divider()
                        Text("Round Trip Distance: \(peak.getRoundTripDistance())")
                        Divider()
                        Text("Peak Description: \(peak.getPeakDescription())")
                        Divider()

                    }
               
                    
                }
            .frame(maxWidth: .infinity, alignment: .center)
                    
            }

        }//List
        .listStyle(.grouped)
        .navigationBarTitle("\(peak.peakName)", displayMode: .large)
        
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    showLogSheet = true
                } label: {
                  
                        Image(systemName: "square.and.pencil").foregroundColor(colorScheme == .dark ? .white : .black)
                    
                    
                    
                    
                }

            }
            ToolbarItem(placement: .keyboard) {
                Button {
                    commentFocused = false
                    
                    UIApplication.shared.sendAction(
                       #selector(UIResponder.resignFirstResponder),
                       to: nil,
                       from: nil,
                       for: nil
                    )
                    
                } label: {
                    Text("Done")
                        .foregroundColor(.blue)
                }
            }
        }
        .sheet(isPresented: $showLogSheet) {
            Text("\(peak.peakName) Log Entry")
                .font(.system(.title, design: .rounded))
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding(.top, 24)
            
            Form {
                Section() {
                    VStack(alignment: .leading) {
                        Text("Date of Hike")
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .underline()
                        TextField("Enter Date...", text: $dateField) {
                            if peakLogEntry != nil {
                                //update
                                handleUpdateLogEntry(logEntry: peakLogEntry!, option: .date)
                            } else {
                                //create
                                handleCreateNewLogEntry(option: .date)
                            }
                        }//onCommit
                    
                    }
                }
                
                Section() {
                    VStack(alignment: .leading) {
                        Text("Season")
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .underline()
                        TextField("Summer, Winter, etc...", text: $seasonField) {
                            if peakLogEntry != nil {
                                //update
                                handleUpdateLogEntry(logEntry: peakLogEntry!, option: .season)
                            } else {
                                //create
                                handleCreateNewLogEntry(option: .season)
                            }
                        }//onCommit
                        
                    }
                }
                
                Section() {
                    VStack(alignment: .leading) {
                        Text("Weather Conditions")
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .underline()
                        TextField("Sunny, rainy, snow & ice, etc...", text: $weatherConditionsField) {
                            if peakLogEntry != nil {
                                //update
                                handleUpdateLogEntry(logEntry: peakLogEntry!, option: .weatherConditions)
                            } else {
                                //create
                                handleCreateNewLogEntry(option: .weatherConditions)
                            }
                        }//onCommit

                    }
                }
                
                Section() {
                    VStack(alignment: .leading) {
                        Text("Comments")
                            .font(.system(.title2, design: .rounded))
                            .bold()
                            .underline()
                        TextEditor(text: $commentsField)
                            .frame(height: 200, alignment: .topLeading)
                            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
                                if peakLogEntry != nil {
                                    //update
                                    handleUpdateLogEntry(logEntry: peakLogEntry!, option: .comments)
                                } else {
                                    //create
                                    handleCreateNewLogEntry(option: .comments)
                                }
                            }
                    }
                    
                }
                
            }
            
        }
        .onAppear() {
            if let entry = peakLogEntry {
                dateField = entry.date
                weatherConditionsField = entry.weatherConditions
                commentsField = entry.comments
                seasonField = entry.season
            }
        }

    }//body
    
}//struct
//
struct PeakDetailView_Previews: PreviewProvider {
    static var previews: some View {

        PeakDetailView( peak: Peaks().highPeaks.first!, selectedTab: .constant(Tabs.list) )

    }
}
