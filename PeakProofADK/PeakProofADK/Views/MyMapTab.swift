//
//  MyMapTab.swift
//  NPF-4
//
//  Created by Taylor Dennison on 11/23/22.
//
import SwiftUI
import CoreLocation
import MapKit

struct MapTypeSelect {
    var title: String
    var map: MKMapType
}

struct MyMapTab: View{
    
    @EnvironmentObject var peaks: Peaks
    @State private var mapView = MapView()
    @State private var zoomedIn = false
    @State private var selectedSegment = 0
    @State private var mapSelect = [MapTypeSelect(title: "Standard", map: .standard), MapTypeSelect(title: "Satellite", map: .satellite), MapTypeSelect(title: "Hybrid", map: .hybrid)]
    
    private var mapType: MapTypeSelect {
        get {
            mapSelect[selectedSegment]
        }
    }

    var selectedPeak: Peak? {
        peaks.selectedHighPeak ?? nil
    }
 
    var body: some View {
        
        ZStack {
            
            mapView
                .onAppear {
                    
                    if (selectedPeak != nil) {
                        mapView.zoomIn(annotation: selectedPeak!)
                        peaks.selectedHighPeak = nil
                    } else {
                        mapView.zoomOut()
                    }
                    
                   
                }//onAppear
                .edgesIgnoringSafeArea(.top)


                Picker(selection: $selectedSegment, label: EmptyView()) {
                    ForEach(0 ..< mapSelect.count) {
                        Text(self.mapSelect[$0].title).tag($0)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 250)
                .offset(x: 60, y:-320)
                .onChange(of: selectedSegment) { newValue in
                    mapView.updateMapType(type: mapSelect[newValue].map)
                }
            
            }
        }
        
    
        
}//MyMapTab

extension MyMapTab {
    func goToDeviceSettings() {
        guard let url = URL.init(string: UIApplication.openSettingsURLString) else {return}
        //must pass empty dictionary for options even if none are used.
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

struct MyMapTab_Previews: PreviewProvider {
    static var previews: some View {
        MyMapTab()
    }
}
