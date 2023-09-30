//
//  ContentView.swift
//  BeaconSender
//
//  Created by krote on 2023/09/22.
//

import SwiftUI

var beacon:IBeaconManager? = nil

struct ContentView: View {
    @State var beaconLog: String = ""
    var body: some View {
        VStack {
            HStack{
                Button("Start", action: {
                    beacon = IBeaconManager()
                    beacon?.initBeacon()
                })
                Button("Stop", action:{
                    beacon?.stopLocalBeacon()
                })
            }
            Text(beaconLog)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
