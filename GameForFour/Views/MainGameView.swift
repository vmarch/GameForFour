//
//  MainGameView.swift
//  GameForFour
//
//  Created by Student on 23.09.21.
//

import SwiftUI

struct MainGameView: View {
    @EnvironmentObject var vm:ViewModel
    
    var body: some View {
        Text("Herzlich willkommen \(vm.userAppName)!!!")
    }
}

struct MainGameView_Previews: PreviewProvider {
    static var previews: some View {
        MainGameView()
    }
}
