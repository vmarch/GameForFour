//
//  GameForFourApp.swift
//  GameForFour
//
//  Created by devtolife on 23.09.21.
//

import SwiftUI

@main
struct GameForFourApp: App {
    @StateObject var dc: ViewModel = ViewModel()
    var body: some Scene {
        WindowGroup {
            NavigationView{
                ContentView()
            }.environmentObject(dc)
        }
    }
}
