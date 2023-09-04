//
//  ContentView.swift
//  swift_hello_world
//
//  Created by Akshin Goswami on 13/8/2023.
//

import SwiftUI
import BrazeKit

struct ContentView: View {
    
    func logBrazeEvent() {
        
    }
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
